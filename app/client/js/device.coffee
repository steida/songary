# PATTERN(steida): Don't use this for responsive CSS, because classes are
# added via JavaScript, which is parsed and runned after HTML is already
# shown. This is for other cases.
# TODO(steida): Move to este library once stabilized.
goog.provide 'app.Device'

goog.require 'goog.dom.classlist'
goog.require 'goog.labs.userAgent.device'

class app.Device

  ###*
    @constructor
  ###
  constructor: ->
    @desktop = goog.labs.userAgent.device.isDesktop()
    @mobile = goog.labs.userAgent.device.isMobile()
    @tablet = goog.labs.userAgent.device.isTablet()

    goog.dom.classlist.enable document.documentElement, 'is-desktop', @desktop
    goog.dom.classlist.enable document.documentElement, 'is-mobile', @mobile
    goog.dom.classlist.enable document.documentElement, 'is-tablet', @tablet