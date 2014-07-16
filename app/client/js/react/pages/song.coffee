goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'
goog.require 'goog.dom.BufferedViewportSizeMonitor'
goog.require 'goog.dom.ViewportSizeMonitor'
goog.require 'goog.dom.classlist'
goog.require 'goog.math.Size'
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
            ref: 'article'
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
        songElSize = @getSize @getDOMNode()
        articleEl = @refs['article'].getDOMNode()
        # TODO(steida): Decide minimal fontSize readability.
        # TODO constanta MINIMAL_READABLE_FONT_SIZE
        fontSize = 5
        @toAvoidUnnecessaryReflow =>
          while fontSize != 55
            articleEl.style.fontSize = "#{fontSize}px"
            articleElSize = @getSize articleEl
            fitsInsideProperly = songElSize.fitsInside articleElSize
            if fitsInsideProperly
              articleEl.style.fontSize = "#{--fontSize}px"
              break
            fontSize++

      getSize: (el) ->
        new goog.math.Size el.offsetWidth, el.offsetHeight

      toAvoidUnnecessaryReflow: (fn) ->
        songEl = @getDOMNode()
        songEl.style.visibility = 'hidden'
        fn()
        songEl.style.visibility = ''

  @MSG_BACK: goog.getMsg 'Back'
  @MSG_EDIT: goog.getMsg 'Edit'
  @HIDE_MENU_DELAY: 2000