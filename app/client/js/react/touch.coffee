goog.provide 'app.react.Touch'

goog.require 'goog.events'

class app.react.Touch

  ###*
    Temp workaround, because React does not support custom attributes yet,
    and Polymer PointerEvents needs touch-action.
    # http://www.polymer-project.org/platform/pointer-events.html#basic-usage
    # TODO(steida): Enforce pointerevents somehow?
    @constructor
  ###
  constructor: ->

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  none: (var_args) ->
    @createTouchableTags arguments, 'none'

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  panX: (var_args) ->
    @createTouchableTags arguments, 'pan-x'

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  panY: (var_args) ->
    @createTouchableTags arguments, 'pan-y'

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  scroll: (var_args) ->
    @createTouchableTags arguments, 'scroll'

  ###*
    @param {Arguments} tags
    @param {string} touchAction
    @return {Object}
    @private
  ###
  createTouchableTags: (tags, touchAction) ->
    obj = {}
    for tag in tags
      obj[tag] = React.createClass
        render: ->
          @transferPropsTo React.DOM[tag] null, @props.children

        componentDidMount: ->
          @getDOMNode().setAttribute 'touch-action', touchAction
          goog.events.listen @getDOMNode(), 'pointerup', @onPointerUp

        componentWillUnmount: ->
          goog.events.unlisten @getDOMNode(), 'pointerup', @onPointerUp

        onPointerUp: (e) ->
          return if !this.props.onPointerUp
          this.props.onPointerUp e
    obj