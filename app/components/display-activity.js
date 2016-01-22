import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

export default Ember.Component.extend({

  tagName: 'li',
  classNames: 'activity list-item',
  model: null,
  pointsLabel: null,

  computeName: Ember.on('init', Ember.observer('model', function() {
    if (!this.model) {
      return;
    }
    const key = this.model.kind === 'challenge-completed' ?
      `challenges.${this.model.details.id}.name` :
      `activities.${this.model.kind}.name`;
    this.set('name', translate(key));
    this.set('icon', translate(`activities.${this.model.kind}.icon`));
    let count = 1;
    if (this.model.details && this.model.details.deltas && this.model.details.deltas.length) {
      count = (this.model.kind === 'delta-lost' ? -1 : 1) * this.model.details.deltas.length;
    }
    this.set('count', count);
  }))

});
