translate = new (require '../helpers/translate')().compute

App.DeltaModel = DS.Model.extend

  # General fields
  kind: DS.attr 'string'
  owners: DS.attr '', detaulsValue: []

  # Computed fields, locale dependant
  name: Ember.computed -> translate "deltas.#{@kind}.name"
  details: Ember.computed -> translate "deltas.#{@kind}.details"
