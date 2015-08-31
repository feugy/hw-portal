require '../components/details-panel'
translate = new (require '../helpers/translate')().compute

App.ChallengesController = Ember.Controller.extend

  # Currently selected challenge, for right panel displayal
  selected: null

  # Because selected title and details are translated with a parametrized info,
  # we must get them manually in the controller
  title: null
  details: null

  actions:

    # Set currently selected challenge: change if different from previous,
    # or reinit to null if toggleing the same challenge.
    #
    # @param {Object} challenge - newly selected challenge.
    select: (challenge) ->
      if @selected is challenge
        @set 'selected', null
      else
        @set 'selected', challenge

      if @selected?
        @set 'title', translate "challenges.#{@selected.id}.name"
        @set 'details', translate "challenges.#{@selected.id}.details"
