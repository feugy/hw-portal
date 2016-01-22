import DS from 'ember-data';

export default DS.RESTSerializer.extend({

  isNewSerializerAPI: true,

  normalize(clazz, hash, prop) {
    if (clazz.modelName === 'stats') {
      hash.id = 0;
    }
    return this._super(clazz, hash, prop);
  }
});
