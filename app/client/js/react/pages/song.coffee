goog.provide 'app.react.pages.Song'

goog.require 'app.device'
goog.require 'goog.dom.BufferedViewportSizeMonitor'
goog.require 'goog.dom.ViewportSizeMonitor'
goog.require 'goog.dom.classlist'
goog.require 'goog.math.Size'
goog.require 'goog.positioning.ViewportClientPosition'
goog.require 'goog.string'

class app.react.pages.Song

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.songs.Store} store
    @constructor
  ###
  constructor: (routes, touch, store) ->
    {div} = touch.scroll 'div'
    {article,menu} = React.DOM
    {a} = touch.none 'a'

    @create = React.createClass

      viewportMonitor: null

      render: ->
        div className: 'song', onPointerUp: @onSongPointerUp,
          article
            dangerouslySetInnerHTML: '__html': @lyricsHtml()
            ref: 'article'
          menu className: 'hidden', ref: 'menu',
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

      onSongPointerUp: (e) ->
        pointerUpOnMenu = goog.dom.contains @menuEl(), e.target
        return if pointerUpOnMenu
        # console.log pointerUpOnMenu
        # show = if pointerUpOnMenu then true else null
        @toggleMenu null, e

      menuEl: ->
        @refs['menu'].getDOMNode()

      ###*
        @param {?boolean} show
        @param {goog.events.BrowserEvent=} e
      ###
      toggleMenu: (show, e) ->
        show ?= goog.dom.classlist.contains @menuEl(), 'hidden'
        goog.dom.classlist.enable @menuEl(), 'hidden', !show
        @positionMenu e if show
        clearTimeout @hideMenuTimer
        @hideMenuAfterWhile() if show

      ###*
        @param {goog.events.BrowserEvent} e
      ###
      positionMenu: (e) ->
        position = new goog.positioning.ViewportClientPosition e.clientX, e.clientY
        position.setLastResortOverflow goog.positioning.Overflow.ADJUST_X | goog.positioning.Overflow.ADJUST_Y
        position.reposition @menuEl(), goog.positioning.Corner.BOTTOM_START

      componentDidMount: ->
        @setLyricsMaxFontSize()
        @createAndListenViewportMonitor()
        @hideMenuAfterWhile()

      componentWillUnmount: ->
        @hideMenu()
        @viewportMonitor.dispose()

      createAndListenViewportMonitor: ->
        @viewportMonitor = new goog.dom
          .BufferedViewportSizeMonitor new goog.dom.ViewportSizeMonitor
        @viewportMonitor.listen 'resize', @setLyricsMaxFontSize

      hideMenuAfterWhile: ->
        clearTimeout @hideMenuTimer
        @hideMenuTimer = setTimeout @hideMenu, Song.HIDE_MENU_DELAY

      hideMenu: ->
        @toggleMenu false

      componentDidUpdate: ->
        # TODO(steida): Implement fontSize increase and decrease.
        # @setLyricsMaxFontSize()

      ###*
        Detect max lyrics fontSize to fit into screen.
      ###
      setLyricsMaxFontSize: ->
        songElSize = @getSize @getDOMNode()
        articleEl = @refs['article'].getDOMNode()
        fontSize = Song.MIN_READABLE_FONT_SIZE
        @toAvoidUnnecessaryReflowAndRepaint =>
          while fontSize != Song.MAX_FONT_SIZE
            articleEl.style.fontSize = "#{fontSize}px"
            articleElSize = @getSize articleEl
            # NOTE(steida): It seems that width is the best UX pattern.
            fitsInsideProperly = articleElSize.width > songElSize.width
            if fitsInsideProperly
              articleEl.style.fontSize = "#{--fontSize}px"
              break
            fontSize++

      getSize: (el) ->
        new goog.math.Size el.offsetWidth, el.offsetHeight

      # TODO(steida): Measure it via Chrome dev tools.
      toAvoidUnnecessaryReflowAndRepaint: (fn) ->
        songEl = @getDOMNode()
        songEl.style.visibility = 'hidden'
        fn()
        songEl.style.visibility = ''

  # TODO(steida): Set by platform.
  @MIN_READABLE_FONT_SIZE: 8
  @MAX_FONT_SIZE: 60
  @MSG_BACK: goog.getMsg 'Back'
  @MSG_EDIT: goog.getMsg 'Edit'
  @HIDE_MENU_DELAY: 2000