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
    {div,article,menu,h1} = React.DOM
    {a} = touch.none 'a'

    @create = React.createClass

      viewportMonitor: null

      render: ->
        div className: 'song',
          article dangerouslySetInnerHTML: '__html': @lyricsHtml()
          menu null,
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

      componentDidMount: ->
        @setLyricsMaxFontSize()
        @viewportMonitor = new goog.dom
          .BufferedViewportSizeMonitor new goog.dom.ViewportSizeMonitor
        @viewportMonitor.listen 'resize', @setLyricsMaxFontSize

      componentWillUnmount: ->
        @viewportMonitor.dispose()

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