/* jshint unused: false */
import french from 'hw-portal/translations/fr';

export function initialize() {
  I18n.fallbacks = true;
  I18n.defaultLocale = 'fr';
  I18n.locale = navigator.userLanguage || navigator.language || 'en';
  console.log(`Current locale is ${I18n.currentLocale()}`);
}

export default {
  name: 'i18n',
  initialize: initialize
};
