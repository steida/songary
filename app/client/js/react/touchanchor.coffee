goog.provide 'app.react.TouchAnchor'

class app.react.TouchAnchor

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {a} = React.DOM

    @create = React.createClass

      render: ->
        @transferPropsTo a null, @props.children

      componentDidMount: ->
        @ensureTouchActionAttribute()

      componentDidUpdate: ->
        @ensureTouchActionAttribute()

      # Because React still does not support touch-action attribute.
      # http://www.polymer-project.org/platform/pointer-events.html#basic-usage
      ensureTouchActionAttribute: ->
        el = @getDOMNode()
        return if el.hasAttribute 'touch-action'
        el.setAttribute 'touch-action', 'none'