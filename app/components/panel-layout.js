import Ember from 'ember';

/**
 * Displays responsive navigation side panels
 * As it will be in every pages, this component fetch it's own data, except session
 *
 * http://discuss.emberjs.com/t/how-to-make-ember-component-fetch-data-from-server-put-ajax-call-
 * inside-the-component-seems-not-a-good-practise-to-handle-this/6984/13
 */
export default Ember.Component.extend({

  classNames: 'off-canvas-wrap l-panel-layout',

  // Current session to get authenticated user
  session: null,
  user: null,

  // Logout checker
  isLogout: false,

  // On session changes, refresh user
  refreshUser: Ember.on('init', Ember.observer('session.content.currentUser', function() {
    this.set('user', this.get('session.content.currentUser'));
    this.set('homeLink', this.get('user') ? 'home' : 'index');
  })),

  // On logout change, performs logout
  performLogout: Ember.observer('isLogout', function() {
    if (this.session) {
      this.session.close();
    }
    this.sendAction('logout');
  }),

  // Foundation's off-canvas component
  attributeBindings: ['offCanvas:data-offcanvas'],
  offCanvas: true,

  init(...args) {
    this._super(...args);
    // Link to home, depending on connection state
    this.homeLink = 'index';
    this.get('targetObject.store').
      queryRecord('stats', {}).
      then(stats => {
        // General statistics displayed
        this.set('stats', stats);
      });
  }
});
