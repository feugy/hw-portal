translator = new (require '../helpers/translate')()

App.DisplayActivityComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'activity list-item'
  model: null
  icon: null
  name: null
  pointsLabel: null

  computeName: ( ->
    return unless @model?
    if @model.kind is 'challenge-completed'
      @set 'name', translator.compute "challenges.#{@model.details.id}.name"
    else
      @set 'name', translator.compute "activities.#{@model.kind}.name"
    @set 'icon', translator.compute "activities.#{@model.kind}.icon"
    count = 1
    if @model.details?.deltas?.length
      count = (if @model.kind is 'delta-lost' then -1 else 1) * @model.details.deltas.length
    @set 'count', count
  ).observes('model').on 'init'
