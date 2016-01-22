import Ember from 'ember';

export default Ember.Component.extend({

  tagName: 'svg',
  classNames: 'delta',

  attributeBindings: ['viewBox', 'preserveAspectRatio'],
  preserveAspectRatio: 'xMidYMid meet',

  // Placeholder currently displayed
  model: null,

  init(...args) {
    this._super(...args);
    // Current size
    this.size = 200;
    this.offset = 5;
  },

  didInsertElement() {
    this.height = this.size * Math.sqrt(3) / 2;
    // TODO performance warning about changing property inside didInsertElement.
    // perhaps wan we defer this ?
    this.set('viewBox', `0 0 ${this.size + this.offset * 2} ${this.height + this.offset * 2}`);
    this.update();
  },

  update() {
    const radius = 0.02;

    this.$('*').remove();
    if (!this.model) {
      return;
    }

    const svg = d3.select(this.$('')[0]);

    svg.append('defs').
      append('pattern').
        attr('id', 'bg').
        attr('viewBox', `0 0 ${this.size} ${this.size}`).
        attr('preserveAspectRatio', 'xMidYMin slice').
        attr('width', 1).
        attr('height', 1).
        append('image').
          attr('width', this.size).
          attr('height', this.size).
          attr('xlink:href', this.model.image);

    svg.selectAll('.placeholder').
      data([this.model]).
      enter().
        append('path').
        attr('class', 'placeholder').
        attr('d', roundPathCorners(`M0,${this.height} L${this.size},${this.height} L${this.size / 2},0 Z`, radius, true)).
        attr('transform', `translate(${this.offset} ${this.offset})`).
        attr('fill', () => 'url(#bg)');
  },

  // When delta are set, updates
  updateRendering: Ember.observer('model', function() {
    Ember.run.scheduleOnce('afterRender', this, this.update);
  })
});
