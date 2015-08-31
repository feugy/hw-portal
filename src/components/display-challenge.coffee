App.DisplayChallengeComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'challenge-card'
  model: null
  overlayPosition: '100%'
  selected: null

  actions:
    select: () ->
      @sendAction 'action', @model

  # Once mode is available, compute toooltip content and trigger progress animation
  initAfterModel: (->
    Ember.run.scheduleOnce 'afterRender', @, =>
      Ember.run.later (=>
        @set 'overlayPosition', 100 - (if @model? then @model.get 'done' else 0) + '%'
      ), 100
  ).observes('model').on 'init'

  # When selected model or model itself is modified, update the selected attribute
  updateSelected: (->
    Ember.run.scheduleOnce 'afterRender', @, => @$('').toggleClass 'selected', @model is @selected
  ).observes('model', 'selected').on 'init'
