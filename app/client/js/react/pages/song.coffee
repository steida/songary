goog.provide 'app.react.pages.Song'

goog.require 'goog.dom.ViewportSizeMonitor'
goog.require 'goog.dom.classlist'
goog.require 'goog.math.Box'
goog.require 'goog.math.Size'
goog.require 'goog.positioning.ViewportClientPosition'
goog.require 'goog.string'

class app.react.pages.Song

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.songs.Store} store
    @param {app.Device} device
    @constructor
  ###
  constructor: (routes, touch, store, device) ->
    {div} = touch.scroll 'div'
    {article, menu} = React.DOM
    {a, menuitem} = touch.none 'a', 'menuitem'

    @create = React.createClass

      viewportMonitor: null

      render: ->
        div className: 'song', onPointerUp: @onSongPointerUp,
          article
            dangerouslySetInnerHTML: '__html': @lyricsHtml()
            ref: 'article'
          menu
            className: 'hidden'
            onMouseEnter: @onMenuMouseHover
            onMouseLeave: @onMenuMouseHover
            ref: 'menu'
          ,
            a
              href: routes.editMySong.createUrl(store.song)
            , Song.MSG_EDIT
            a
              href: routes.home.createUrl()
              ref: 'back'
            , Song.MSG_BACK
            menuitem
              onPointerUp: @onFontResizeButtonPointerUp.bind @, true
            , '+'
            menuitem
              onPointerUp: @onFontResizeButtonPointerUp.bind @, false
            , '-'

      lyricsHtml: ->
        goog.string
          .htmlEscape store.song.lyrics
          .replace /\[([^\]]+)\]/g, (str, chord) ->
            "<sup>#{chord}</sup>"

      onSongPointerUp: (e) ->
        pointerUpOnMenu = goog.dom.contains @ref('menu'), e.target
        return if pointerUpOnMenu
        @toggleMenu null, new goog.math.Coordinate e.clientX, e.clientY

      onMenuMouseHover: (e) ->
        return if not device.desktop
        if e.type == 'mouseenter'
          clearTimeout @hideMenuTimer
        else
          @hideMenuAfterWhile()

      onFontResizeButtonPointerUp: (increase) ->
        if not device.desktop
          clearTimeout @hideMenuTimer
          @hideMenuAfterWhile()
        fontSize = parseInt @ref('article').style.fontSize, 10
        if increase then fontSize++ else fontSize--
        @ref('article').style.fontSize = "#{fontSize}px"

      ###*
        NOTE(steida): Nice pattern. Mixin? Pull request to React?
        @param {string} name
        @return {Element}
      ###
      ref: (name) ->
        @refs[name].getDOMNode()

      ###*
        @param {?boolean} show
        @param {goog.math.Coordinate=} mouseCoord
      ###
      toggleMenu: (show, mouseCoord) ->
        show ?= goog.dom.classlist.contains @ref('menu'), 'hidden'
        goog.dom.classlist.enable @ref('menu'), 'hidden', !show
        @positionMenu mouseCoord if show
        clearTimeout @hideMenuTimer
        @hideMenuAfterWhile() if show

      hideMenu: ->
        @toggleMenu false

      positionMenu: (mouseCoord) ->
        # NOTE(steida): It seems that after rotation change iOS Safari
        # caches size until scroll, so sometimes x or y is not adjusted.
        position = new goog.positioning.ViewportClientPosition mouseCoord
        overflow = goog.positioning.Overflow.ADJUST_X | goog.positioning.Overflow.ADJUST_Y
        position.setLastResortOverflow overflow
        position.reposition @ref('menu'),
          goog.positioning.Corner.TOP_START, @getDeviceMarginBox()

      getDeviceMarginBox: ->
        top = -(@ref('menu').offsetHeight / 2)
        left =
          @ref('back').getBoundingClientRect().right -
          @ref('menu').getBoundingClientRect().left

        if device.mobile
          top -= @ref('menu').offsetHeight
          left -= Song.LEFT_THUMB_AVERAGE_X_OFFSET

        new goog.math.Box top, 0, 0, -left

      componentDidMount: ->
        @setLyricsMaxFontSize()
        @createAndListenViewportSizeMonitor()
        @hideMenu()

      componentWillUnmount: ->
        @hideMenu()
        @viewportMonitor.dispose()

      createAndListenViewportSizeMonitor: ->
        # NOTE(steida): Update UI asap. If it doesn't work, downgrade to
        # goog.dom.BufferedViewportSizeMonitor.
        @viewportMonitor = new goog.dom.ViewportSizeMonitor
        @viewportMonitor.listen 'resize', @onViewportSizeMonitorResize

      onViewportSizeMonitorResize: (e) ->
        @hideMenu()
        @setLyricsMaxFontSize()

      hideMenuAfterWhile: ->
        clearTimeout @hideMenuTimer
        @hideMenuTimer = setTimeout @hideMenu, Song.HIDE_MENU_DELAY

      ###*
        Detect max lyrics fontSize to fit into screen.
      ###
      setLyricsMaxFontSize: ->
        songElSize = @getSize @getDOMNode()
        fontSize = Song.MIN_READABLE_FONT_SIZE
        @toAvoidUnnecessaryReflowAndRepaint =>
          while fontSize != Song.MAX_FONT_SIZE
            @ref('article').style.fontSize = "#{fontSize}px"
            articleElSize = @getSize @ref('article')
            # NOTE(steida): It seems that width is the best UX pattern.
            fitsInsideProperly = articleElSize.width > songElSize.width
            if fitsInsideProperly
              @ref('article').style.fontSize = "#{--fontSize}px"
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
  @HIDE_MENU_DELAY: 2000
  @MAX_FONT_SIZE: 60
  @MIN_READABLE_FONT_SIZE: 8
  @MSG_BACK: goog.getMsg 'back'
  @MSG_EDIT: goog.getMsg 'edit'
  @LEFT_THUMB_AVERAGE_X_OFFSET: 16