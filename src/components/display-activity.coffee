translate = new (require '../helpers/translate')().compute

App.DisplayActivityComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'activity list-item'
  model: null
  pointsLabel: null

  computeName: ( ->
    return unless @model?
    if @model.kind is 'challenge-completed'
      @set 'name', translate "challenges.#{@model.details.id}.name"
    else
      @set 'name', translate "activities.#{@model.kind}.name"
    @set 'icon', translate "activities.#{@model.kind}.icon"
    count = 1
    if @model.details?.deltas?.length
      count = (if @model.kind is 'delta-lost' then -1 else 1) * @model.details.deltas.length
    @set 'count', count
  ).observes('model').on 'init'
