App.IndexController = Ember.Controller.extend

  user: null

  refreshUser: ( ->
    @set 'user', @session?.content?.currentUser
  ).observes('session.content.currentUser').on 'init'

  actions:

    # Scrolls to a particular target within the parallax element
    #
    # @param {String} target - css selector to find the target
    scrollTo: (target) ->
      target = Ember.$ target
      throw new Error "No target #{target} found" unless target?.length
      parallax = Ember.$ '.l-parallax'
      parallax.animate scrollTop: target.position().top - parallax.children().first().position().top
