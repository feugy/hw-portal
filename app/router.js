import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('connect');
  this.route('home');
  this.route('rankings');
  this.route('settings');
  this.route('challenges', function() {
    this.route('details', {path: '/:id'});
  });
  this.route('collection', function() {
    this.route('details', {path: '/:kind'});
  });
});

export default Router;
