AuthenticatedRoute = require './authenticated'
require '../models/delta'
require '../models/scene'
require '../components/details-panel'
require '../controllers/collection'

App.CollectionRoute = AuthenticatedRoute.extend

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
          if data.scenes?
            data.scenes = (for scene in data.scenes
              @store.push @store.normalize 'scene', scene
            )
          resolve data
        .fail reject
