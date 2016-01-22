App.DeltaPlaceholderComponent = Ember.Component.extend

  tagName: 'svg'
  classNames: 'delta'

  attributeBindings: ['viewBox', 'preserveAspectRatio']
  preserveAspectRatio: 'xMidYMid meet'

  # Placeholder currently displayed
  model: null

  init: (args...) ->
    @_super args...
    # Current size
    @size = 200
    @offset = 5

  didInsertElement: ->
    @height = @size * Math.sqrt(3) / 2
    @set 'viewBox', "0 0 #{@size + @offset * 2} #{@height + @offset * 2}"
    @update()

  update: ->
    radius = 0.02

    @$('*').remove()
    return unless @model?

    svg = d3.select @$('')[0]

    svg.append 'defs'
      .append 'pattern'
        .attr 'id', 'bg'
        .attr 'viewBox', "0 0 #{@size} #{@size}"
        .attr 'preserveAspectRatio', 'xMidYMin slice'
        .attr 'width', 1
        .attr 'height', 1
        .append 'image'
          .attr 'width', @size
          .attr 'height', @size
          .attr 'xlink:href', @model.image

    svg.selectAll '.placeholder'
      .data [@model]
      .enter()
        .append 'path'
        .attr 'class', 'placeholder'
        .attr 'd', roundPathCorners "M0,#{@height} L#{@size},#{@height} L#{@size / 2},0 Z", radius, true
        .attr 'transform', "translate(#{@offset} #{@offset})"
        .attr 'fill', (placeholder) -> 'url(#bg)'

  # When delta are set, updates
  updateRendering: (->
    Ember.run.scheduleOnce 'afterRender', @, @update
  ).observes 'model'
