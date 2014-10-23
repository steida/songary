goog.provide 'server.Passport'

class server.Passport

  ###*
    req.isAuthenticated(), req.user, req.logout();
    @param {Function} passport
    @param {Function} Strategy
    @constructor
  ###
  constructor: (@passport, Strategy) ->
    @passport.serializeUser (user, done) ->
      done null, user.id

    @passport.deserializeUser (id, done) ->
      # findById id, (err, user) ->
      #   done err, user

    # @passport.use new Strategy
    #   usernameField: 'email',
    #   passwordField: 'token'
    # , (email, token, done) ->
    #   console.log email, token

      # ověřit app id, user id, a jestli ho vubec mam v db, pak ho nacist
      # done err if err
      # done null, false # Unknown user or invalid password
      # done null, user

  ###*
    @param {Object} app Express app.
  ###
  use: (app) ->
    app.use @passport.initialize()
    app.use @passport.session()
