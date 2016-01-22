require '../components/panel-layout'
require '../components/infinity-scroll'
require '../components/ranking-gamer'

criteria = [
  label: 'btn.sortByScore', title: 'ttl.generalRanking', field: 'score'
,
  label: 'btn.sortByTrophies', title: 'ttl.trophiesRanking', field: 'trophyCount'
,
  label: 'btn.sortByDeltas', title: 'ttl.deltasRanking', field: 'deltaCount'
]

App.RankingsController = Ember.Controller.extend

  # sort field can be set in route as query parameter
  queryParams: ['sort']
  sort: criteria[0].field

  # acceptable sort criterias
  sortCriteria: criteria

  # current sort criteria
  currentSort: null

  # store ranking list scroll-top position to make it persistent accross navigation
  scrollPosition: 0

  updateSort: (->
    sort = @get 'sort'
    @set 'currentSort', criteria.find (criterion) -> criterion.field is sort
  ).observes('sort').on 'init'
