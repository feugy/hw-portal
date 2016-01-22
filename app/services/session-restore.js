import Ember from 'ember';

export default Ember.Service.extend({

  init() {
    this._super(...arguments);
    this.fetched = false;
  },

  restore() {
    if (this.fetched) {
      return Ember.RSVP.resolve();
    }
    const session = this.container.lookup('service:session');
    console.log('Try to restore previous session');
    return session.fetch().
      then(() => console.log(`${session.content && session.content.currentUser && session.content.currentUser.get('pseudo')} re-authentified`)).
      catch(err => {
        // just listen to error to avoid bubbling
        console.log('no session to restore', err && err.message || err);
      }).
      finally(() => this.fetched = true);
  }
});
