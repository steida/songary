goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.react.Login} login
    @constructor
  ###
  constructor: (login) ->
    {footer,p} = React.DOM

    @component = React.createClass
      render: ->
        footer {},
          login.component {}
          p className: 'text-warning', Footer.MSG_WARNING

  @MSG_WARNING: goog.getMsg "Warning: Pre-alpha version, don't use it yet."
