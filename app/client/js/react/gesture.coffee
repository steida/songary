goog.provide 'app.react.Gesture'

goog.require 'goog.dom.classlist'
goog.require 'goog.object'

class app.react.Gesture

  ###*
    Helper for github.com/Polymer/polymer-gestures.
    Example: {a, span, button} = gesture.none 'a', 'span', 'button'
    TODO: Move to este-library. Check if tap can safely stop scroll momentum.
    @param {este.events.RoutingClickHandler} routingClickHandler
    @constructor
    @final
  ###
  constructor: (@routingClickHandler) ->

    ###*
      Prevent "ghost click" phenomenon. Ghost clicks occur when an element
      is removed before the 300ms delayed click event is fired, but the
      click event is still sent. This click event will be sent to whatever
      is now on top at that coordinate.
      This PR is trying to fix it, but it does not work in iOS Chrome.
      https://github.com/Polymer/polymer-gestures/pull/73
      TODO: Wait for polymer-gestures fix.
      @type {Element}
      @private
    ###
    @cover_ = document.createElement 'div'
    @cover_.style.cssText = 'position: fixed; top: 0; left: 0; background-color: #000; opacity: 0; width: 100%; height: 100%; z-index: 2147483647;'

  ###*
    Used for removing touch-hover before iOS callout is shown.
    @type {number}
  ###
  @CALLOUT_DELAY: 750

  ###*
    @type {number}
  ###
  @COVER_DELAY: 350

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
    cover = @cover_
    gestures = window['PolymerGestures']
    routingClickHandler = @routingClickHandler

    React.createFactory React.createClass

      render: ->
        props = goog.object.clone @props
        onKeyUp = props.onKeyUp
        props.onKeyUp = (e) =>
          onKeyUp e if onKeyUp
          # Ignore unfocusable tab index.
          return if @getDOMNode().tabIndex == -1
          # Enter/backspace to dispatch tap, because native click is bypassed.
          @onTap e if e.key in ['Enter', ' ']
        React.createElement tag, props

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
        node = @getDOMNode()
        # Give React time to update view without blinking on slow mobile.
        # .active css state is not applied immediately.
        # TODO: Instead of hover or touch-hover, router should control link
        # active style.
        setTimeout =>
          try
            goog.dom.classlist.remove node, 'touch-hover'
          catch e
        , 10
        clearTimeout @touchHoverHideTimer
        @props.onUp e if @props.onUp
        return

      onTap: (e) ->
        @props.onTap e if @props.onTap
        @showCoverTemporarily_()
        if @getDOMNode().tagName == 'A'
          @delegateAnchorTapToRoutingClickHandler_ e
        return

       showCoverTemporarily_: ->
        # Seems to be more reliable then display block/none.
        return if cover.parentNode == document.body
        document.body.appendChild cover
        clearTimeout @coverHideTimer
        @coverHideTimer = setTimeout ->
          document.body.removeChild cover
        , Gesture.COVER_DELAY

      delegateAnchorTapToRoutingClickHandler_: (e) ->
        routingClickHandler.onCustomClick e
