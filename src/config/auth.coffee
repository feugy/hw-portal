window.ENV.torii =
  sessionServiceName: 'session'
  providers:
    'github-oauth2':
      apiKey: '9c31116c5a8dcf0e26f7'
      scope: 'user'

    'google-oauth2':
      apiKey: '1018497886467-g2g9p8lhmdgtjfckqbkvhdfjl9pk2bm8.apps.googleusercontent.com'
      scope: 'profile'
      redirectUri: Ember.computed () ->
        "#{window.location.protocol}//#{window.location.host}#{window.location.pathname}"
