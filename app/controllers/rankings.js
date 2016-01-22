import Ember from 'ember';

const criteria = [{
  label: 'btn.sortByScore', title: 'ttl.generalRanking', field: 'score'
}, {
  label: 'btn.sortByTrophies', title: 'ttl.trophiesRanking', field: 'trophyCount'
}, {
  label: 'btn.sortByDeltas', title: 'ttl.deltasRanking', field: 'deltaCount'
}];

export default Ember.Controller.extend({

  // sort field can be set in route as query parameter
  queryParams: ['sort'],
  sort: criteria[0].field,

  // acceptable sort criterias
  sortCriteria: criteria,

  // current sort criteria
  currentSort: null,

  // store ranking list scroll-top position to make it persistent accross navigation
  scrollPosition: 0,

  updateSort: Ember.on('init', Ember.observer('sort', function() {
    const sort = this.get('sort');
    this.set('currentSort', criteria.find(criterion => criterion.field === sort));
  }))
});
