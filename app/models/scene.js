import DS from 'ember-data';
import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

export default DS.Model.extend({

  // General fields
  placeholders: DS.attr(),
  deltaSize: DS.attr('number', {defaultValue: 100}),

  // Computed fields, locale dependant
  name: Ember.computed(function() {
    return translate(`scenes.${this.id}.name`);
  })
});
