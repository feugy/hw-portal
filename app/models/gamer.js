import DS from 'ember-data';

export default DS.Model.extend({
  // General fields
  pseudo: DS.attr('string'),
  score: DS.attr('number', {defaultValue: 0}),
  deltaCount: DS.attr('number', {defaultValue: 0}),
  trophyCount: DS.attr('number', {defaultValue: 0}),

  // Connected gamer specific fields
  email: DS.attr('string'),
  provider: DS.attr('string')
});
