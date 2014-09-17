goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Link} link
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (routes, link, userStore) ->
    {header,nav} = React.DOM

    @component = React.createClass
      render: ->
        header {},
          nav {},
            link.to routes.home, Header.MSG_MY_SONGS
            # link.to routes.songs, Header.MSG_SONGS
            link.to routes.about, Header.MSG_ABOUT
            if userStore.isLogged()
              link.to routes.me, Header.MSG_ME

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_ME: goog.getMsg 'Me'
  @MSG_MY_SONGS: goog.getMsg 'My Songs'
  @MSG_SONGS: goog.getMsg 'Songs'
