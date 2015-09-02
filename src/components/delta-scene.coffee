App.DeltaSceneComponent = Ember.Component.extend

  tagName: 'svg'
  classNames: 'delta-scene'

  attributeBindings: ['viewBox', 'preserveAspectRatio']
  viewBox: '0 0 1024 512'
  preserveAspectRatio: 'xMidYMid meet'

  # Array of deltas owned by the current player
  collection: []

  # Scene currently displayed
  model: null

  # Selected placeholder currently displayed
  selected: null

  didInsertElement: ->
    # Give a try on https://css-tricks.com/scale-svg/ option 4 for IE
    # option 5 does not handle clicks
    @svg = d3.select @$('')[0]

    # Creates a shadow filter
    shadow = @svg.append 'defs'
      .append 'filter'
        .attr id: 'shadow', width: '150%', height: '150%', x: '-25%', y: '-25%'
    shadow.append 'feGaussianBlur'
      .attr in: 'SourceAlpha'
    shadow.append 'feOffset'
      .attr result: 'offsetblur'
    shadow.append 'feFlood'
      # Must match the CSS shadow-color variable
      .attr 'flood-color': '#999'
    shadow.append 'feComposite'
      .attr in2: 'offsetblur', operator: 'in'
    merge = shadow.append 'feMerge'
    merge.append 'feMergeNode'
    merge.append 'feMergeNode'
      .attr 'in', 'SourceGraphic'

    @updateScene()

  updateScene: ->
    size = @model.get 'deltaSize'
    height = size * Math.sqrt(3) / 2
    radius = 0 #0.05
    path = roundPathCorners "M0,0 L#{size},0 L#{size / 2},#{-height} Z", radius, true

    placeholders = @svg.selectAll('.placeholder').data @model.get 'placeholders'

    # Enter section: to create new node for new data
    group = placeholders.enter()
      .append 'g'
        .attr 'class', 'placeholder'
        .attr 'transform', (d) -> "translate(#{d.position})"
        .on 'click', (placeholder) => @sendAction 'action', placeholder
    group.append 'path'
      .attr 'class', 'delta'
      .attr 'd', path
    group.append 'path'
      .attr 'class', 'owned'
      .style 'display', 'none'
      .attr 'd', path
    group.append 'text'
      .attr 'class', 'label'
      .attr 'transform', "translate(#{size / 2} #{height / -2.5})"

    # Update section: to update newly and existing nodes
    placeholders.classed 'selected', (placeholder) => placeholder.kind is @selected?.kind

    placeholders.select '.owned'
      .style 'display', (placeholder) =>
        owned = @collection.find (delta) -> placeholder.kind is delta.get 'kind'
        if owned? then 'inherit' else 'none'

    # Fill text if multiple deltas of this kind are owned
    placeholders.select '.label'
      .text (placeholder) =>
        num = @collection.filter((delta) -> placeholder.kind is delta.get 'kind').length
        if num > 1 then num else ''

    # Add image
    placeholders.select '.delta'
      .attr 'filter', null
      .attr 'fill', (placeholder) -> "url(##{placeholder.kind})"
      .each (placeholder) =>
        @svg.select("##{placeholder.kind}").remove()
        @svg.select('defs').append 'pattern'
          .attr 'id', placeholder.kind
          .attr 'viewBox', "0 0 #{size} #{size}"
          .attr 'preserveAspectRatio', 'xMidYMin slice'
          .attr 'width', 1
          .attr 'height', 1
          .append 'image'
            .attr 'width', size
            .attr 'height', size
            .attr 'xlink:href', placeholder.image

    @animateSelected()

    # Exit section: to remove node that do not represent data anymore
    placeholders.exit().remove()

  # As we can't apply CSS box-shadow and css transition to SVG node,
  # we must manually apply a shadow filter and animates its properties
  animateSelected: ->
    # These values must match CSS values
    animDuration = 300
    shadowHeight = 8

    # Apply the filter
    @svg.select('.selected .delta').attr 'filter', 'url(#shadow)'

    # Animates it
    @svg.select('#shadow feGaussianBlur')
      .attr 'stdDeviation', 0
      .transition().duration animDuration
        .attr 'stdDeviation', shadowHeight * 1.5
    @svg.select('#shadow feOffset')
      .attr 'dy', 0
      .transition().duration animDuration
        .attr 'dy', shadowHeight

  # When delta are set, updates
  updateRendering: (->
    Ember.run.scheduleOnce 'afterRender', @, @updateScene
  ).observes 'model.placeholders', 'selected', 'collection'
