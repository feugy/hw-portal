App.RankingGamerComponent = Ember.Component.extend

  tagName: 'li'
  classNames: 'gamer list-item'
  idx: null
  gamer: null
  rank: null
  avatarSize: 50

  computeRank: ( ->
    @set 'rank', 1 + @get 'idx'
  ).observes('idx').on 'init'
