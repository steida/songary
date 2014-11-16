goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, usersStore, element) ->
    {header, nav, Link} = element

    @component = React.createFactory React.createClass
      render: ->
        header {},
          nav {},
            Link
              route: routes.home
              activeFor: [routes.editSong, routes.newSong, routes.trash]
            , Header.MSG_MY_SONGS
            Link
              route: routes.songs
              activeFor: [routes.recentlyUpdatedSongs]
            , Header.MSG_SONGS
            Link
              route: routes.about
            , Header.MSG_ABOUT
            if usersStore.isLogged()
              Link
                route: routes.me
              , Header.MSG_ME

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_ME: goog.getMsg 'Me'
  @MSG_MY_SONGS: goog.getMsg 'My Songs'
  @MSG_SONGS: goog.getMsg 'Songs'
