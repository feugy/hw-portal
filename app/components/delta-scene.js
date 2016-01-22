import Ember from 'ember';

export default Ember.Component.extend({

  tagName: 'svg',
  classNames: 'delta-scene',

  attributeBindings: ['viewBox', 'preserveAspectRatio'],
  viewBox: '0 0 1024 512',
  preserveAspectRatio: 'xMidYMid meet',

  // Array of deltas owned by the current player
  collection: [],

  // Scene currently displayed
  model: null,

  // Selected placeholder currently displayed
  selected: null,

  didInsertElement() {
    // Give a try on https://css-tricks.com/scale-svg/ option 4 for IE
    // option 5 does not handle clicks
    this.svg = d3.select(this.$('')[0]);

    // Creates a shadow filter
    const shadow = this.svg.append('defs').
      append('filter').
        attr({id: 'shadow', width: '150%', height: '150%', x: '-25%', y: '-25%'});
    shadow.append('feGaussianBlur').
      attr({in: 'SourceAlpha'});
    shadow.append('feOffset').
      attr({result: 'offsetblur'});
    shadow.append('feFlood').
      // Must match the CSS shadow-color variable
      attr({'flood-color': '#999'});
    shadow.append('feComposite').
      attr({in2: 'offsetblur', operator: 'in'});
    const merge = shadow.append('feMerge');
    merge.append('feMergeNode');
    merge.append('feMergeNode').
      attr('in', 'SourceGraphic');

    this.updateScene();
  },

  updateScene() {
    const size = this.model.get('deltaSize');
    const height = size * Math.sqrt(3) / 2;
    const radius = 0.02;
    const path = roundPathCorners(`M0,0 L${size},0 L${size / 2},${-height} Z`, radius, true);

    const placeholders = this.svg.selectAll('.placeholder').data(this.model.get('placeholders'));

    // Enter section: to create new node for new data
    const group = placeholders.enter().
      append('g').
        attr('class', 'placeholder').
        attr('transform', (d) => `translate(${d.position})`).
        on('click', (placeholder) => this.sendAction('action', placeholder));
    group.append('path').
      attr('class', 'delta').
      attr('d', path);
    group.append('path').
      attr('class', 'owned').
      style('display', 'none').
      attr('d', path);
    group.append('text').
      attr('class', 'label').
      attr('transform', `translate(${size / 2} ${height / -2.5})`);

    // Update section: to update newly and existing nodes
    placeholders.classed('selected', (placeholder) => placeholder.kind === this.selected && this.selected.kind);

    placeholders.select('.owned').
      style('display', (placeholder) => {
        const owned = this.collection.find((delta) => placeholder.kind === delta.get('kind'));
        return owned ? 'inherit' : 'none';
      });

    // Fill text if multiple deltas of this kind are owned
    placeholders.select('.label').
      text((placeholder) => {
        const num = this.collection.filter((delta) => placeholder.kind === delta.get('kind')).length;
        return num > 1 ? num : '';
      });

    // Add image
    placeholders.select('.delta').
      attr('filter', null).
      attr('fill', (placeholder) => `url(#${placeholder.kind})`).
      each((placeholder) => {
        this.svg.select(`#${placeholder.kind}`).remove();
        this.svg.select('defs').append('pattern').
          attr('id', placeholder.kind).
          attr('viewBox', `0 0 ${size} ${size}`).
          attr('preserveAspectRatio', 'xMidYMin slice').
          attr('width', 1).
          attr('height', 1).
          append('image').
            attr('width', size).
            attr('height', size).
            attr('xlink:href', placeholder.image);
      });

    this.animateSelected();

    // Exit section: to remove node that do not represent data anymore
    placeholders.exit().remove();
  },

  // As we can't apply CSS box-shadow and css transition to SVG node,
  // we must manually apply a shadow filter and animates its properties
  animateSelected() {
    // These values must match CSS values
    const animDuration = 300;
    const shadowHeight = 8;

    // Apply the filter
    this.svg.select('.selected .delta').attr('filter', 'url(#shadow)');

    // Animates it
    this.svg.select('#shadow feGaussianBlur').
      attr('stdDeviation', 0).
      transition().duration(animDuration).
        attr('stdDeviation', shadowHeight * 1.5);
    this.svg.select('#shadow feOffset').
      attr('dy', 0).
      transition().duration(animDuration).
        attr('dy', shadowHeight);
  },

  // When delta are set, updates
  updateRendering: Ember.observer('model.placeholders', 'selected', 'collection', function() {
    Ember.run.scheduleOnce('afterRender', this, this.updateScene);
  })
});
