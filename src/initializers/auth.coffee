Ember.Application.initializer
  name: 'auth-init'
  after: 'torii-session'

  initialize: (container, application) ->
    application.deferReadiness()
    console.log 'Try to restore previous session'
    session = container.lookup 'torii:session'
    session.fetch()
      .then (data) ->
        console.log "#{session.content?.currentUser?.get 'pseudo'} re-authentified"
      .catch (err) ->
        # just listen to error to avoid bubbling
        console.log 'no session to restore', err?.message or err
      .finally ->
        application.advanceReadiness()
