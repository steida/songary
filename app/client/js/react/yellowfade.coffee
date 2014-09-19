goog.provide 'app.react.YellowFade'

goog.require 'goog.dom.classlist'

class app.react.YellowFade

  ###*
    @constructor
  ###
  constructor: ->

  ###*
    @param {Element|Object} arg
  ###
  on: (arg) ->
    return if !arg
    # To allow React ref.
    el = if arg.getDOMNode
      arg.getDOMNode()
    else
      arg
    goog.dom.classlist.remove el, 'yellow-fade'
    setTimeout ->
      goog.dom.classlist.add el, 'yellow-fade'
    , 0
