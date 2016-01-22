import DS from 'ember-data';
import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

export default DS.Model.extend({

  // General fields
  kind: DS.attr('string'),
  owners: DS.attr('', {detaulsValue: []}),

  // Computed fields, locale dependant
  name: Ember.computed(function () {
    return translate(`deltas.${this.kind}.name`);
  }),
  details: Ember.computed(function () {
    return translate(`deltas.${this.kind}.details`);
  }),
});
