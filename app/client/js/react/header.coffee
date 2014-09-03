goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (routes, touch, userStore) ->
    {header,nav} = React.DOM
    {a} = touch.none 'a'

    # TODO: To injectable helper.
    linkTo = (route, text) ->
      a
        className: if routes.active == route then 'active' else null
        href: route.url()
      , text

    @component = React.createClass
      render: ->
        header {}, nav {},
          linkTo routes.home, Header.MSG_MY_SONGS
          linkTo routes.about, Header.MSG_ABOUT
          linkTo routes.me, Header.MSG_ME if userStore.isLogged()

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_ME: goog.getMsg 'Me'
  @MSG_MY_SONGS: goog.getMsg 'My Songs'
