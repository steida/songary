goog.provide 'app.react.Gesture'

goog.require 'goog.dom.classlist'

class app.react.Gesture

  ###*
    Helper for github.com/Polymer/polymer-gestures.
    TODO: Move to este-library. Check if tap can safely stop scroll momentum.

    Example:
    {a,span,button} = touch.none 'a', 'span', 'button'

    @param {este.events.RoutingClickHandler} routingClickHandler
    @constructor
    @final
  ###
  constructor: (@routingClickHandler) ->

  ###*
    Used for removing touch-hover before iOS callout is shown.
    @type {number}
  ###
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
    gestures = window['PolymerGestures']
    routingClickHandler = @routingClickHandler

    React.createClass

      render: ->
        @transferPropsTo React.DOM[tag] null, @props.children

      componentDidMount: ->
        # Undefined at server side, so do nothing.
        return if !gestures

        # React doesn't support this non standard attribute, so add it manually.
        @getDOMNode().setAttribute 'touch-action', touchAction
        if tag == 'a'
          routingClickHandler.enableCustomClick @getDOMNode()

        gestures.addEventListener @getDOMNode(), 'down', @onDown
        gestures.addEventListener @getDOMNode(), 'up', @onUp
        gestures.addEventListener @getDOMNode(), 'tap', @onTap

      componentWillUnmount: ->
        return if !gestures
        gestures.removeEventListener @getDOMNode(), 'down', @onDown
        gestures.removeEventListener @getDOMNode(), 'up', @onUp
        gestures.removeEventListener @getDOMNode(), 'tap', @onTap

      onDown: (e) ->
        goog.dom.classlist.add @getDOMNode(), 'touch-hover'
        @removeTouchHoverBeforeTouchCalloutTimeouted()
        @props.onDown e if @props.onDown
        return

      removeTouchHoverBeforeTouchCalloutTimeouted: ->
        clearTimeout @touchHoverHideTimer
        @touchHoverHideTimer = setTimeout =>
          return if !@isMounted()
          goog.dom.classlist.remove @getDOMNode(), 'touch-hover'
        , Gesture.CALLOUT_DELAY

      onUp: (e) ->
        goog.dom.classlist.remove @getDOMNode(), 'touch-hover'
        clearTimeout @touchHoverHideTimer
        @props.onUp e if @props.onUp
        return

      onTap: (e) ->
        @props.onTap e if @props.onTap
        if e.target.tagName == 'A'
          @delegateAnchorTapToRoutingClickHandler_ e
        return

      delegateAnchorTapToRoutingClickHandler_: (e) ->
        routingClickHandler.onCustomClick e
