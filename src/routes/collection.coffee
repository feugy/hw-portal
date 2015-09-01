require '../models/delta'
require '../components/details-panel'
require '../controllers/collection'

App.CollectionRoute = Ember.Route.extend

  # Redirect to index if not authenticated
  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  # Get collection content, either player's own deltas and existing scenes
  model: ->
    new Ember.RSVP.Promise (resolve, reject) =>
      Ember.$.getJSON('/data/collection.json')
        .done (data) =>
          # Enrich data with model when possible
          if data.deltas?
            data.deltas = (for delta in data.deltas
              @store.push @store.normalize 'delta', delta
            )
          console.log 'end model'
          resolve data
        .fail reject
