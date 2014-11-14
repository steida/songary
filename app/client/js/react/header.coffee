goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @param {este.react.Link} link
    @constructor
  ###
  constructor: (routes, usersStore, element, link) ->
    {header, nav} = element

    @component = React.createFactory React.createClass
      render: ->
        header {}, nav {},
          link.to
            route: routes.home
            activeFor: [routes.editSong, routes.newSong, routes.trash]
          , Header.MSG_MY_SONGS
          link.to
            route: routes.songs
            activeFor: [routes.recentlyUpdatedSongs]
          , Header.MSG_SONGS
          link.to
            route: routes.about
          , Header.MSG_ABOUT
          if usersStore.isLogged()
            link.to
              route: routes.me
            , Header.MSG_ME

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_ME: goog.getMsg 'Me'
  @MSG_MY_SONGS: goog.getMsg 'My Songs'
  @MSG_SONGS: goog.getMsg 'Songs'
