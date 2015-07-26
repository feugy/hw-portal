App.RankingGamerComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'gamer list-item'
  sort: null
  gamer: null
  list: null
  rank: null
  avatarSize: 50

  computeRank: ( ->
    list = @get 'list'
    rank = list.indexOf @get 'gamer'
    criterion = @get 'sort'
    value = @get "gamer.#{criterion}"
    # to display ex-aequo, search for previous gamers with the same score
    rank-- while value is list.objectAt([rank - 1])?.get criterion
    @set 'rank', rank + 1
  ).observes('idx').on 'init'
