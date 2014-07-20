# TODO(steida): Move to este library once stabilized.
goog.provide 'app.Zoom'

class app.Zoom

  ###*
    TODO(steida): Experimental, don't use it.
    PATTERN(steida): It would be awesome to be able to control which pages
    should be zoomable, and which not. Unfortunatelly, in iOS it seems to be
    impossible to reset scale back to 1 after user leaved scaled page via JS.
    Also, positioning sucks. But users are used to do two fingers scroll, so we
    need to provide them alternative way to scale content.
    @constructor
  ###
  constructor: ->
    @meta = document.querySelector 'meta[name=viewport]'

  ###*
    @param {boolean} enable
  ###
  enable: (enable) ->
    # TODO(steida): Check Android etc. http://stackoverflow.com/a/21721335
    @meta.setAttribute 'content', if enable
      'width=device-width, initial-scale=1.0'
    else
      'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'