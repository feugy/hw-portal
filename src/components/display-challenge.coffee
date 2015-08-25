translate = new (require '../helpers/translate')().compute
formatDate = new (require '../helpers/date-time')().compute

App.DisplayChallengeComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'challenge-card'
  model: null
  overlayPosition: '100%'
  tooltip: ''

  # Declare instance variable, especially the tooltip that must not act as static
  init: (args...) ->
    @_super args...
    @set 'tooltip', ''

  # Once mode is available, compute toooltip content and trigger progress animation
  initAfterModel: (->

    if @model?
      # as we can't have HTML content in title attribute (due to some htmlbars parser failure),
      # we compite the content in the component, using translate and date-time helpers
      title = translate "challenges.#{@model.id}.name"
      details = translate "challenges.#{@model.id}.details"
      if @model.get('earned')?
        earned = "<div class='earned'>#{translate 'lbl.challengeEarned'}#{formatDate @model.get 'earned'}</div>"
      else
        earned = ''
      @set 'tooltip', "
        <h3>#{title}</h3>
        <div class='content'>#{details}</div>
        #{earned}
        <div class='points right' >#{translate 'lbl.activityPoints', points: @model.get 'points'}</div>"

    Ember.run.scheduleOnce 'afterRender', @, =>
      # reflaw challenge's tooltip, and set position with a delay, to allow smooth transition
      @$('li').foundation 'tooltip', 'reflow'
      Ember.run.later (=>
        @set 'overlayPosition', 100 - (if @model? then @model.get 'done' else 0) + '%'
      ), 100
  ).observes('model').on 'init'
