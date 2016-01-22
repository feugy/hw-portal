import Ember from 'ember';

export default Ember.Component.extend({

  tagName: 'li',
  classNames: 'gamer list-item',
  sort: null,
  gamer: null,
  list: null,
  avatarSize: 50,

  computeRank: Ember.on('init', Ember.observer('idx', function() {
    const list = this.get('list');
    let rank = list.indexOf(this.get('gamer'));
    const criterion = this.get('sort');
    const value = this.get(`gamer.${criterion}`);
    // to display ex-aequo, search for previous gamers with the same score
    while(value === (list.objectAt([rank - 1]) && list.objectAt([rank - 1]).get(criterion))) {
      rank--;
    }
    this.set('rank', rank + 1);
  }))
});
