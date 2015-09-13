require '../components/edit-account'

App.SettingsController = Ember.Controller.extend

  # Distinguish between account coming from external providers (no password)
  isExternal: false

  # Save result for main account
  mainSuccessfullySaved: null

  # On module update, reset the isExternal status
  modelUpdated: (->
    @set 'mainSuccessfullySaved', null
    # Only internal users can edit their password and email
    @set 'isExternal', 'huby-woky' isnt @get 'model.accounts.main.provider'
  ).observes('model').on 'init'

  actions:

    # Triggered when main account needs to be saved
    #
    # @param {Object} edited - new values for pseudo, email, password...
    saveMainAccount: (edited) ->
      console.log 'saved main', edited
      Ember.$.post('/data/settings.json', edited, () =>
        @set 'mainSuccessfullySaved', true
        # TODO update model from what returned server
      , 'json').fail (xhr, status, err) =>
        @set 'mainSuccessfullySaved', err or status
