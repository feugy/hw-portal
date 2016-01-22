import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

const signInEvents = ['signIn.login', 'signIn.password', 'signIn.confirm'];
const logInEvents = ['logIn.login', 'logIn.password'];

export default Ember.Controller.extend({

  connectError: null,

  /*
   * Log-in form fields and state
   */
  logIn: {
    valid: false,
    login: null,
    password: null,
    loginMissing: false,
    passwordMissing: false
  },

  /**
   * Sign-in form fields and state
   */
  signIn: {
    valid: false,
    login: null,
    password: null,
    confirm: null,
    loginMissing: false,
    passwordMissing: false,
    confirmDiffers: false
  },

  /**
   * Updates error flags when editing sign-in fields.
   * Clear log-in fields.
   */
  checkSignIn() {
    const loginLength = this.signIn.login && this.signIn.login.trim().length || 0;
    const passwordLength = this.signIn.password && this.signIn.password.trim().length || 0;
    this.set('signIn.loginMissing', loginLength === 0);
    this.set('signIn.passwordMissing', passwordLength === 0);
    this.set('signIn.confirmDiffers', this.signIn.password !== this.signIn.confirm);
    this.set('signIn.valid', !(this.signIn.loginMissing || this.signIn.passwordMissing || this.signIn.confirmDiffers));

    // unwire observer for log-in reset
    for (let event of logInEvents) {
      this.removeObserver(event, this, this.checkLogIn);
    }
    this.set('logIn', {
      valid: false,
      login: null,
      password: null,
      loginMissing: false,
      passwordMissing: false,
      inhibit: false
    });
    for (let event of logInEvents) {
      this.addObserver(event, this, this.checkLogIn);
    }
  },

  /**
   * Updates error flags when editing log-in fields.
   * Clear sign-in fields.
   */
  checkLogIn() {
    const loginLength = this.logIn.login && this.logIn.login.trim().length || 0;
    const passwordLength = this.logIn.password && this.logIn.password.trim().length || 0;
    this.set('logIn.loginMissing', loginLength === 0);
    this.set('logIn.passwordMissing', passwordLength === 0);
    this.set('logIn.valid', !(this.logIn.loginMissing || this.logIn.passwordMissing));

    // unwire observer for sign-in reset
    for (let event of signInEvents) {
      this.removeObserver(event, this, this.checkSignIn);
    }
    this.set('signIn', {
      valid: false,
      login: null,
      password: null,
      confirm: null,
      loginMissing: false,
      passwordMissing: false,
      confirmDiffers: false,
      inhibit: false
    });
    for (let event of signInEvents) {
      this.addObserver(event, this, this.checkSignIn);
    }
  },

  init(...args) {
    this._super(...args);
    this.emailPlaceholder = translate('plh.email');
    this.passwordPlaceholder = translate('plh.password');
    this.passwordConfirmPlaceholder = translate('plh.passwordConfirm');

    // Because of their cyclic nature, checkLogIn and checkSignIn must be manually
    // wired and unwired, and not use Ember.run.Once to keep their synchronism
    for (let event of signInEvents) {
      this.addObserver(event, this, this.checkSignIn);
    }
    for (let event of logInEvents) {
      this.addObserver(event, this, this.checkLogIn);
    }
  },

  actions: {
    closeConnectError() {
      this.set('connectError', null);
    }
  }
});
