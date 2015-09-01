translator = new (require '../helpers/translate')()

App.DeltaModel = DS.Model.extend

  # General fields
  kind: DS.attr 'string'
  owners: DS.attr()
  lastOwner: DS.attr 'string', defaultValue: null

  # Computed fields, locale dependant
  name: Ember.computed -> translator.compute "deltas.#{@kind}.name"
  details: Ember.computed -> translator.compute "deltas.#{@kind}.details"
