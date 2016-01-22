translate = new (require '../helpers/translate')().compute

App.ChallengeModel = DS.Model.extend

  # General fields
  points: DS.attr 'number', defaultValue: 0
  limit: DS.attr 'date', defaultValue: null
  earned: DS.attr 'date', defaultValue: null
  done: DS.attr 'number', defaultValue: 0
  category: DS.attr 'string'

  # Computed fields, locale dependant
  name: Ember.computed -> translate "challenges.#{@id}.name"
  details: Ember.computed -> translate "challenges.#{@id}.details"
  icon: Ember.computed -> translate "challenges.#{@id}.icon"
