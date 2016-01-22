import DS from 'ember-data';

export default DS.RESTAdapter.extend({
  namespace: 'data',
  pathForType(type) {
    return `${this._super(type)}.json`;
  }
});
