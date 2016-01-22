import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  deltaCount: DS.attr('number', {defaultValue: 0}),
  playerCount: DS.attr( 'number', {defaultValue: 0})
});

Ember.Inflector.inflector.uncountable('stats');
