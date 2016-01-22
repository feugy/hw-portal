import DS from 'ember-data';
import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

export default DS.Model.extend({

  // General fields
  points: DS.attr('number', {defaultValue: 0}),
  limit: DS.attr('date', {defaultValue: null}),
  earned: DS.attr('date', {defaultValue: null}),
  done: DS.attr('number', {defaultValue: 0}),
  category: DS.attr('string'),

  // Computed fields, locale dependant
  name: Ember.computed(function() {
    return translate(`challenges.${this.id}.name`);
  }),
  details: Ember.computed(function() {
    return translate(`challenges.${this.id}.details`);
  }),
  icon: Ember.computed(function() {
    return translate(`challenges.${this.id}.icon`);
  })
});
