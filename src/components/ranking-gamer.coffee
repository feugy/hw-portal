App.RankingGamerComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'gamer list-item'
  gamer: null
  list: null
  rank: null
  avatarSize: 50

  computeRank: ( ->
    list = @get 'list'
    rank = list.indexOf @get 'gamer'
    score = @get 'gamer.score'
    # to display ex-aequo, search for previous gamers with the same score
    rank-- while score is list.objectAt([rank - 1])?.get 'score'
    @set 'rank', rank + 1
  ).observes('idx').on 'init'
