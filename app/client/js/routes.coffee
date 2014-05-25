goog.provide 'app.Routes'
goog.provide 'app.Routes.EventType'

goog.require 'este.Route'
goog.require 'goog.events.EventTarget'

class app.Routes extends goog.events.EventTarget

  ###*
    @constructor
    @extends {goog.events.EventTarget}
    @final
  ###
  constructor: ->
    super()
    @home = new este.Route '/'
    @newSong = new este.Route '/songs/new'

  ###*
    @enum {string}
  ###
  @EventType:
    CHANGE: 'change'

  ###*
    @type {este.Route}
    @private
  ###
  active_: null

  ###*
    @param {este.Route} route
  ###
  setActive: (route) ->
    @active_ = route
    @dispatchEvent Routes.EventType.CHANGE

  ###*
    @return {este.Route}
  ###
  getActive: ->
    @active_