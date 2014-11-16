goog.provide 'app.react.pages.NotFound'

class app.react.pages.NotFound

  ###*
    @param {app.Routes} routes
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, element) ->
    {div, h1, p, Link} = element

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          h1 {}, NotFound.MSG_H1
          p {}, NotFound.MSG_P
          Link route: routes.home, NotFound.MSG_LINK

  @MSG_H1: goog.getMsg "This page isn't available"
  @MSG_P: goog.getMsg 'The link may be broken, or the page may have been removed.'
  @MSG_LINK: goog.getMsg 'Continue here please.'
