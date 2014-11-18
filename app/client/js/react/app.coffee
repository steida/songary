goog.provide 'app.react.App'

goog.require 'goog.dom'
goog.require 'goog.events'

class app.react.App

  ###*
    @param {app.Title} title
    @param {app.react.Pages} pages
    @param {este.react.Element} element
    @param {app.Actions} actions
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (title, pages, element, actions, songsStore, usersStore) ->
    {div} = element

    @component = React.createFactory React.createClass

      render: ->
        div className: 'app',
          pages.component()
          # Fix warning: The "fb-root" div has not been created, auto-creating.
          div id: 'fb-root'

      componentDidMount: ->
        actions.listen 'change', @onStoreChange
        songsStore.listen 'change', @onStoreChange
        usersStore.listen 'change', @onStoreChange
        goog.events.listen window, 'orientationchange', @onOrientationChange

      onStoreChange: ->
        @forceUpdate()

      onOrientationChange: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0

      componentDidUpdate: ->
        document.title = title.get()
