goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Link} link
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (routes, link, usersStore) ->
    {header,nav} = React.DOM

    @component = React.createFactory React.createClass
      render: ->
        header {},
          nav {},
            link.to
              route: routes.home
              text: Header.MSG_MY_SONGS
              activeFor: [routes.editSong, routes.newSong, routes.trash]
            link.to routes.songs, Header.MSG_SONGS
            link.to routes.about, Header.MSG_ABOUT
            if usersStore.isLogged()
              link.to routes.me, Header.MSG_ME

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_ME: goog.getMsg 'Me'
  @MSG_MY_SONGS: goog.getMsg 'My Songs'
  @MSG_SONGS: goog.getMsg 'Songs'
