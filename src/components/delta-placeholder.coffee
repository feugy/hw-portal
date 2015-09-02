App.DeltaPlaceholderComponent = Ember.Component.extend

  tagName: 'svg'
  classNames: 'delta'

  attributeBindings: ['viewBox', 'preserveAspectRatio']
  preserveAspectRatio: 'xMidYMid meet'

  # Current size
  size: 200
  offset: 5

  # Placeholder currently displayed
  model: null

  didInsertElement: ->
    @height = @offset + @size * Math.sqrt(3) / 2
    @set 'viewBox', "0 0 #{@size + @offset * 2} #{@height + @offset}"
    @update()

  update: ->
    radius = 0 #0.05

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
        .attr 'd', roundPathCorners "
          M#{@offset},#{@height}
          L#{@offset + @size},#{@height}
          L#{@offset + @size / 2}, #{@offset} Z
        ", radius, true
        .attr 'fill', (placeholder) -> 'url(#bg)'

  # When delta are set, updates
  updateRendering: (->
    Ember.run.scheduleOnce 'afterRender', @, @update
  ).observes 'model'
