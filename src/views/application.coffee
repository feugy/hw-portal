App.ApplicationView = Ember.View.extend
  initFoundation: ( ->
    Ember.$(document).foundation()
  ).on 'didInsertElement'
