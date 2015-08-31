
require '../components/display-challenge'
require '../components/details-panel'
translate = new (require '../helpers/translate')().compute

App.ChallengesController = Ember.Controller.extend

  queryParams: ['current']
  current: null

  # Currently selected challenge, for right panel displayal
  selected: Ember.computed 'model', 'current',
    get: ->
      return null unless @current? and @model?
      selected = @model.find (challenge) => @current is challenge.get 'id'
      @updateDetails selected
      selected

    set: (key, selected) ->
      @set 'current', selected?.get('id') or null
      @updateDetails selected
      selected

  # Because selected title and details are translated with a parametrized info,
  # we must get them manually in the controller
  title: null
  details: null

  updateDetails: (selected) ->
    if selected?
      @set 'title', translate "challenges.#{selected.id}.name"
      @set 'details', translate "challenges.#{selected.id}.details"

  actions:

    # Set currently selected challenge: change if different from previous,
    # or reinit to null if toggleing the same challenge.
    #
    # @param {Object} challenge - newly selected challenge.
    select: (challenge) ->
      selected = @get 'selected'
      if challenge is selected
        @set 'selected', null
      else
        @set 'selected', challenge
