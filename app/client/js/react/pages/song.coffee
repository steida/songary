goog.provide 'app.react.pages.Song'

goog.require 'goog.dom.ViewportSizeMonitor'
goog.require 'goog.dom.classlist'
goog.require 'goog.labs.userAgent.device'
goog.require 'goog.math.Box'
goog.require 'goog.math.Size'
goog.require 'goog.positioning.ViewportClientPosition'
goog.require 'goog.string'

class app.react.pages.Song

  ###*
    @param {app.Routes} routes
    @param {app.react.Gesture} gesture
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (routes, gesture, userStore) ->
    {div} = gesture.scroll 'div'
    {article,menu} = React.DOM
    {a,menuitem} = gesture.none 'a', 'menuitem'

    @component = React.createFactory React.createClass

      viewportMonitor: null

      render: ->
        song = @props.song

        # onUp, because onTap does not dispatch clientX and clientY yet.
        div className: 'page', onUp: @onSongUp,
          article
            dangerouslySetInnerHTML: '__html': @lyricsHtml song
            ref: 'article'
          menu
            className: 'hidden'
            onMouseEnter: @onMenuMouseHover
            onMouseLeave: @onMenuMouseHover
            ref: 'menu'
          ,
            a href: routes.home.url(), ref: 'back', Song.MSG_BACK
            menuitem
              onTap: @onFontResizeTap.bind @, true
            , '+'
            menuitem
              onTap: @onFontResizeTap.bind @, false
            , '-'
            if userStore.songById song.id
              a href: routes.editSong.url(song), Song.MSG_EDIT
            else
              menuitem
                onTap: @onSaveToDeviceTap
              , Song.MSG_SAVE_TO_DEVICE

      ref: (name) ->
        @refs[name].getDOMNode()

      lyricsHtml: (song) ->
        goog.string
          .htmlEscape song.getDisplayLyrics()
          .replace /\[([^\]]+)\]/g, (str, chord) ->
            "<sup>#{chord}</sup>"

      onSongUp: (e) ->
        tapOnMenu = goog.dom.contains @ref('menu'), e.target
        return if tapOnMenu
        @toggleMenu null, new goog.math.Coordinate e.clientX, e.clientY

      onMenuMouseHover: (e) ->
        return if !goog.labs.userAgent.device.isDesktop()
        if e.type == 'mouseenter'
          clearTimeout @hideMenuTimer
        else
          @hideMenuAfterWhile()

      # TODO: Use polymer-gestures once pinch event will be supported.
      onFontResizeTap: (increase, e) ->
        e.stopPropagation()
        if !goog.labs.userAgent.device.isDesktop()
          clearTimeout @hideMenuTimer
          @hideMenuAfterWhile()
        fontSize = parseInt @ref('article').style.fontSize, 10
        if increase then fontSize++ else fontSize--
        @ref('article').style.fontSize = "#{fontSize}px"

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
        # It seems that after rotation change iOS Safari caches size until
        # scroll, so sometimes x or y is not adjusted.
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

        if !goog.labs.userAgent.device.isDesktop()
          top -= @ref('menu').offsetHeight
          left -= Song.LEFT_THUMB_AVERAGE_X_OFFSET

        new goog.math.Box top, 0, 0, -left

      componentDidMount: ->
        @setLyricsMaxFontSize()
        @createAndListenViewportSizeMonitor()
        @hideMenu()

      componentDidUpdate: ->
        @setLyricsMaxFontSize()

      componentWillUnmount: ->
        @hideMenu()
        @viewportMonitor.dispose()

      createAndListenViewportSizeMonitor: ->
        # Update font size asap seems to be the best. In case of problems,
        # downgrade to goog.dom.BufferedViewportSizeMonitor.
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
            # It seems that width is the best UX pattern.
            fitsInsideProperly = articleElSize.width > songElSize.width
            if fitsInsideProperly
              @ref('article').style.fontSize = "#{--fontSize}px"
              break
            fontSize++

      getSize: (el) ->
        new goog.math.Size el.offsetWidth, el.offsetHeight

      # TODO: Measure it via Chrome dev tools.
      toAvoidUnnecessaryReflowAndRepaint: (fn) ->
        songEl = @getDOMNode()
        songEl.style.visibility = 'hidden'
        fn()
        songEl.style.visibility = ''

      onSaveToDeviceTap: ->
        userStore.savePublishedSongToDevice @props.song

  # TODO: Set by platform.
  @HIDE_MENU_DELAY: 2000
  @MAX_FONT_SIZE: 60
  @MIN_READABLE_FONT_SIZE: 8
  @LEFT_THUMB_AVERAGE_X_OFFSET: 16

  @MSG_BACK: goog.getMsg 'Back'
  @MSG_EDIT: goog.getMsg 'Edit'
  @MSG_SAVE_TO_DEVICE: goog.getMsg 'Save To Device'
