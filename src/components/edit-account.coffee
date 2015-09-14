translate = new (require '../helpers/translate')().compute

# Sends two different actions:
# - default one when save button is pressed, with edited value and original model
# - 'updateFromProvider' with original model when external provider data must be retrieved
App.EditAccountComponent = Ember.Component.extend

  tagName: 'form'
  classNames: 'account'

  # Distinguish between account coming from external providers, that has no password (set by controller)
  isExternal: false
  # Edidted account (set by controller)
  model: null
  # Set to true if successfully saved, to an object in case of error,
  # or to null if no save operation triggered (set by controller)
  successfullySaved: null

  # On component initialization, set locale dependent fields
  init: (args...) ->
    @_super args...
    @passwordType = 'password'
    @passwordPlaceholder = translate 'plh.passwordEdition'

  # When model is updated, set edited values to reflect it
  modelUpdated: (->
    Ember.run.once @, =>
      return unless @model?
      @set 'edited',
        pseudo: @get 'model.pseudo'
        email: @get 'model.email'
        password: ''
  ).observes('model').on 'init'

  # Updates the canSave flag everytime an edited value changes
  editedUpdate: (->
    Ember.run.once @, =>
      if @model? and @edited?
        @set 'canSave', @edited.pseudo isnt @get('model.pseudo') or
          @edited.email isnt @get('model.email') or
          @edited.password isnt ''
      else
        @set 'canSave', false
  ).observes('edited.pseudo', 'edited.email', 'edited.password').on 'init'

  # Updates saveResult and saveResultStyles to reflect the current status.
  statusUpdated: (->
    Ember.run.once @, =>
      # Bu default, hides alert-box
      result = null
      @set 'saveResultStyle', 'success'

      if @successfullySaved?
        # if truthy, display success message
        if @successfullySaved
          result = translate 'msg.accountSaved'
        else
          # Or consider as an error object
          @set 'saveResultStyle', 'alert'
          result = translate 'err.accountNotSaved', err: @successfullySaved
      @set 'saveResult', result
      @modelUpdated()
  ).observes('successfullySaved').on 'init'

  actions:
    # When password field gains focus, its content becames readable
    editPassword: ->
      @set 'passwordType', 'text'

    # When password field looses focus, it's obfuscated
    stopEditPassword: ->
      @set 'passwordType', 'password'

    # Retrieve email address from external provider if needed
    updateFromProvider: ->
      return unless @isExternal
      # trigger update on server
      @sendAction 'updateFromProvider', @model

    # Closes  alert-box displaying save result
    closeSaveResult: ->
      @set 'saveResult', null

    # Save edited values to server
    save: ->
      return unless @canSave
      @send 'closeSaveResult'
      @sendAction 'action', @edited, @model
