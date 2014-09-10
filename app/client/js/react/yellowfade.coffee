goog.provide 'app.react.YellowFade'

goog.require 'goog.dom.classlist'

class app.react.YellowFade

  ###*
    @constructor
  ###
  constructor: ->

  ###*
    @param {Element} el
  ###
  on: (el) ->
    return if !el
    goog.dom.classlist.remove el, 'yellow-fade'
    setTimeout ->
      goog.dom.classlist.add el, 'yellow-fade'
    , 0
