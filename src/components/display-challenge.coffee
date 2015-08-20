
App.DisplayChallengeComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'challenge-card'
  model: null
  overlayPosition: '100%'

  displayOverlay: (->
    Ember.run.scheduleOnce 'afterRender', @, =>
      Ember.run.later (=>
        @set 'overlayPosition', (if @model? then @model.get 'done' else 100) + '%'
      ), 100
  ).observes('model').on 'init'
