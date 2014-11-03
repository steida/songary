goog.provide 'server.Middleware'

class server.Middleware

  ###*
    @param {Function} compression
    @param {Function} cookieParser
    @param {Function} cookieSecret
    @param {Function} expressSession
    @param {Function} favicon
    @param {Function} methodOverride
    @param {Object} bodyParser
    @constructor
  ###
  constructor: (@compression, @cookieParser, @cookieSecret, @expressSession, @favicon,
    @methodOverride, @bodyParser) ->

  ###*
    @param {Object} app Express app.
  ###
  use: (app) ->
    app.use @compression()
    app.use @favicon 'app/client/img/favicon.ico'
    app.use @cookieParser @cookieSecret
    app.use @bodyParser.urlencoded extended: false
    app.use @bodyParser.json()
    app.use @methodOverride()
    app.use @expressSession
      resave: false
      saveUninitialized: false
      # https://github.com/sahat/hackathon-starter/issues/169#issuecomment-59042128
      # TODO: Use external configuration.
      secret: 'songarydemo'
