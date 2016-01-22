import Ember from 'ember';
import AuthenticatedRoute from 'hw-portal/routes/authenticated';

export default AuthenticatedRoute.extend({

  // Get collection content, either player's own deltas and existing scenes
  model() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      Ember.$.getJSON('/data/collection.json').
        done(data => {
          // Enrich data with model when possible
          if (data.deltas) {
            data.deltas = data.deltas.map(delta => this.store.push(this.store.normalize('delta', delta)));
          }
          if (data.scenes) {
            data.scenes = data.scenes.map(scene => this.store.push(this.store.normalize('scene', scene)));
          }
          resolve(data);
        }).
        fail(reject);
    });
  }
});
