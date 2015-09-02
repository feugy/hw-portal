translate = new (require '../helpers/translate')().compute

App.DeltaModel = DS.Model.extend

  # General fields
  kind: DS.attr 'string'
  owners: DS.attr()
  lastOwner: DS.attr 'string', defaultValue: null

  # Computed fields, locale dependant
  name: Ember.computed -> translate "deltas.#{@kind}.name"
  details: Ember.computed -> translate "deltas.#{@kind}.details"
