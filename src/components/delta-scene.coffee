App.DeltaSceneComponent = Ember.Component.extend

  tagName: 'svg'
  classNames: 'delta-scene'

  attributeBindings: ['viewBox', 'preserveAspectRatio']
  viewBox: '0 0 1024 512'
  preserveAspectRatio: 'xMidYMid meet'

  # Scene currently displayed
  model: null

  # Selected kind currently displayed
  selected: null

  didInsertElement: ->
    # Give a try on https://css-tricks.com/scale-svg/ option 4 for IE
    # option 5 does not handle clicks
    @svg = d3.select @$('')[0]

    # Initialize d3
    @updateScene()

  updateScene: ->
    # Update d3 scene by adding new delta, removing old ones, and updating existings
    deltas = @svg.selectAll  '.delta'
      .data @model.deltas, (delta) -> delta.kind

    size = @model.deltaSize or 100
    height = size * Math.sqrt(3) / 2

    deltas.enter()
      .append 'path'
        .attr 'd', "M0,0h#{size}l#{size / -2},#{-height}z"
        .attr 'transform', (d) -> "translate(#{d.position})"
        .attr 'class', 'triangle'
        .classed 'selected', (delta) => delta.kind is @selected
        .on 'click', (delta) => @sendAction 'action', delta.kind

    deltas.exit().remove()

  # When delta are set, updates
  updateRendering: (->
    Ember.run.scheduleOnce 'afterRender', @, @updateScene
  ).observes 'model.deltas', 'selected'
