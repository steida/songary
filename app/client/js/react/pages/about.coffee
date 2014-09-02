goog.provide 'app.react.pages.About'

class app.react.pages.About

  ###*
    @constructor
  ###
  constructor: ->
    {div,p} = React.DOM

    @component = React.createClass

      render: ->
        div className: 'page',
          p {}, About.MSG_P

  @MSG_P: goog.getMsg 'Songary. Your songbook.'
