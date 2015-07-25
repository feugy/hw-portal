App.GamerModel = DS.Model.extend
  pseudo: DS.attr 'string'
  score: DS.attr 'number', defaultValue: 0
  deltaCount: DS.attr 'number', defaultValue: 0
  trophyCount: DS.attr 'number', defaultValue: 0
