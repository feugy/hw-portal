import AuthenticatedRoute from 'hw-portal/routes/authenticated';

export default AuthenticatedRoute.extend({

  model() {
    return this.store.findAll('challenge');
  }
});
