App.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'data'
  suffix: '.json'
  pathForType: (type) -> "#{@_super(type)}.json"
