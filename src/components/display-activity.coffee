translator = new (require '../helpers/translate')()

App.DisplayActivityComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'activity list-item'
  activity: null
  icon: null
  name: null
  pointsLabel: null

  computeName: ( ->
    return unless @activity?
    if @activity.kind is 'challenge-completed'
      @set 'name', translator.compute "challenges.#{@activity.details.id}.name"
    else
      @set 'name', translator.compute "activities.#{@activity.kind}.name"
    @set 'icon', translator.compute "activities.#{@activity.kind}.icon"
    count = 1
    if @activity.details?.deltas?.length
      count = (if @activity.kind is 'delta-lost' then -1 else 1) * @activity.details.deltas.length
    @set 'count', count
  ).observes('activity').on 'init'
