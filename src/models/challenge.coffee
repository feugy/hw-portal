translator = new (require '../helpers/translate')()

App.ChallengeModel = DS.Model.extend

  # General fields
  points: DS.attr 'number', defaultValue: 0
  limit: DS.attr 'date', defaultValue: null
  earned: DS.attr 'date', defaultValue: null
  done: DS.attr 'number', defaultValue: 0
  category: DS.attr 'string'

  # Computed fields, locale dependant
  name: Ember.computed -> translator.compute "challenges.#{@id}.name"
  details: Ember.computed -> translator.compute "challenges.#{@id}.details"
  icon: Ember.computed -> translator.compute "challenges.#{@id}.icon"
