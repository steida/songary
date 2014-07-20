# TODO(steida): Wait for a while then move into este library.
goog.provide 'app.react.Touch'

goog.require 'goog.dom.classlist'
goog.require 'goog.events'

class app.react.Touch

  ###*
    Temp workaround, because React does not support custom attributes yet,
    and Polymer PointerEvents needs touch-action.
    # http://www.polymer-project.org/platform/pointer-events.html#basic-usage
    @constructor
  ###
  constructor: ->

  ###* @type {number} ###
  @CALLOUT_DELAY: 750

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  none: (var_args) ->
    @createTouchableComponents arguments, 'none'

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  panX: (var_args) ->
    @createTouchableComponents arguments, 'pan-x'

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  panY: (var_args) ->
    @createTouchableComponents arguments, 'pan-y'

  ###*
    @param {...string} var_args
    @return {Object}
  ###
  scroll: (var_args) ->
    # NOTE(steida): scroll doesn't work anymore for some reason.
    # http://www.polymer-project.org/platform/pointer-events.html
    @createTouchableComponents arguments, 'pan-x pan-y'

  ###*
    @param {Arguments} tags
    @param {string} touchAction
    @return {Object}
  ###
  createTouchableComponents: (tags, touchAction) ->
    obj = {}
    obj[tag] = @createTouchableComponent tag, touchAction for tag in tags
    obj

  ###*
    @param {string} tag
    @param {string} touchAction
    @return {function(): React.ReactComponent}
  ###
  createTouchableComponent: (tag, touchAction) ->
    React.createClass
      render: ->
        @transferPropsTo React.DOM[tag] null, @props.children

      componentDidMount: ->
        @getDOMNode().setAttribute 'touch-action', touchAction
        goog.events.listen @getDOMNode(), 'pointerdown', @onPointerDown
        goog.events.listen @getDOMNode(), 'pointerup', @onPointerUp

      componentWillUnmount: ->
        goog.events.unlisten @getDOMNode(), 'pointerdown', @onPointerDown
        goog.events.unlisten @getDOMNode(), 'pointerup', @onPointerUp

      onPointerDown: (e) ->
        goog.dom.classlist.add @getDOMNode(), 'touch-hover'
        @removeTouchHoverBeforeTouchCallout()
        return if !this.props.onPointerDown
        this.props.onPointerDown e

      onPointerUp: (e) ->
        goog.dom.classlist.remove @getDOMNode(), 'touch-hover'
        clearTimeout @touchHoverHideTimer
        return if !this.props.onPointerUp
        this.props.onPointerUp e

      removeTouchHoverBeforeTouchCallout: ->
        clearTimeout @touchHoverHideTimer
        @touchHoverHideTimer = setTimeout =>
          return if !@isMounted()
          goog.dom.classlist.remove @getDOMNode(), 'touch-hover'
        , Touch.CALLOUT_DELAY