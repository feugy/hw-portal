translate = new (require '../helpers/translate')().compute

App.SceneModel = DS.Model.extend

  # General fields
  placeholders: DS.attr()
  deltaSize: DS.attr 'number', defaultValue: 100

  # Computed fields, locale dependant
  name: Ember.computed -> translate "scenes.#{@id}.name"
