App.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'title', 'Hello world!'
