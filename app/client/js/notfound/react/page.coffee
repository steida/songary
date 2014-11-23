goog.provide 'app.notFound.react.Page'

class app.notFound.react.Page

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
          h1 {}, Page.MSG_H1
          p {}, Page.MSG_P
          Link route: routes.home, Page.MSG_LINK

  @MSG_H1: goog.getMsg "This page isn't available"
  @MSG_P: goog.getMsg 'The link may be broken, or the page may have been removed.'
  @MSG_LINK: goog.getMsg 'Continue here please.'
