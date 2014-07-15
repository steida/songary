goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'
goog.require 'goog.dom.BufferedViewportSizeMonitor'
goog.require 'goog.dom.ViewportSizeMonitor'
goog.require 'goog.dom.classlist'
goog.require 'goog.string'

class app.react.pages.Song

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} store
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, store, touch) ->
    {div,menu,h1} = React.DOM
    {article} = touch.scroll 'article'
    {a} = touch.none 'a'

    @create = React.createClass

      viewportMonitor: null

      render: ->
        div className: 'song',
          article
            dangerouslySetInnerHTML: '__html': @lyricsHtml()
            onPointerUp: @onArticlePointerUp
          menu ref: 'menu',
            a
              href: routes.home.createUrl(),
            , Song.MSG_BACK
            a
              href: routes.editMySong.createUrl(store.song),
            , Song.MSG_EDIT

      lyricsHtml: ->
        goog.string
          .htmlEscape store.song.lyrics
          .replace /\[([^\]]+)\]/g, (str, chord) ->
            "<sup>#{chord}</sup>"

      onArticlePointerUp: ->
        @toggleMenu()

      toggleMenu: ->
        goog.dom.classlist.toggle @refs['menu'].getDOMNode(), 'este-hidden'

      componentDidMount: ->
        @setLyricsMaxFontSize()
        @createAndListenViewportMonitor()
        @hideMenuAfterWhile()

      componentWillUnmount: ->
        clearTimeout @hideMenuTimer
        @viewportMonitor.dispose()

      createAndListenViewportMonitor: ->
        @viewportMonitor = new goog.dom
          .BufferedViewportSizeMonitor new goog.dom.ViewportSizeMonitor
        @viewportMonitor.listen 'resize', @setLyricsMaxFontSize

      hideMenuAfterWhile: ->
        clearTimeout @hideMenuTimer
        @hideMenuTimer = setTimeout @toggleMenu, Song.HIDE_MENU_DELAY

      componentDidUpdate: ->
        # TODO(steida): Implement fontSize increase and decrease.
        # @setLyricsMaxFontSize()

      ###*
        Detect max lyrics fontSize to fit into screen.
        TODO(steida): Implement and describe strategies.
      ###
      setLyricsMaxFontSize: ->
        el = @getDOMNode()
        originalVisibility = el.style.visibility
        el.style.visibility = 'hidden'
        fontSize = 5
        while fontSize != 55
          el.style.fontSize = "#{fontSize}px"
          scrollbarIsVisible =
            el.scrollHeight > el.offsetHeight ||
            el.scrollWidth > el.offsetWidth
          if scrollbarIsVisible
            el.style.fontSize = "#{--fontSize}px"
            break
          fontSize++
        el.style.visibility = originalVisibility

  @MSG_BACK: goog.getMsg 'Back'
  @MSG_EDIT: goog.getMsg 'Edit'
  @HIDE_MENU_DELAY: 2000