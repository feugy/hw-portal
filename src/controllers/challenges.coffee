require '../components/display-challenge'
require '../components/details-panel'

App.ChallengesController = Ember.Controller.extend

  # Currently selected challenge, for right panel displayal
  selected: null

  # When the selected challenge is reseted to null, return back to challenges route
  # The transition to details route must only be performed in the select action
  # Do not performs on init, because we must wait for Challenges.Details route
  # to set this value
  updateSelected: (->
    @transitionToRoute 'challenges' unless @selected?
  ).observes 'selected'

  actions:

    # Set currently selected challenge: change if different from previous,
    # or reinit to null if toggleing the same challenge.
    # Transition to the selected challenge details
    #
    # @param {Object} challenge - newly selected challenge.
    select: (challenge) ->
      selected = @get 'selected'
      if challenge is selected
        @set 'selected', null
      else
        @set 'selected', challenge
        @transitionToRoute 'challenges.details', challenge.id if challenge?
