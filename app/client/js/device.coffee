# TODO(steida): Move to este library once stabilized.
goog.provide 'app.device'

goog.require 'goog.dom.classlist'
goog.require 'goog.labs.userAgent.device'

do ->
  classlist = goog.dom.classlist
  device = goog.labs.userAgent.device
  html = document.documentElement

  # PATTERN(steida): Set class asap.
  classlist.enable html, 'is-desktop', device.isDesktop()
  classlist.enable html, 'is-mobile', device.isMobile()
  classlist.enable html, 'is-tablet', device.isTablet()

  app.device.desktop = device.isDesktop()
  app.device.mobile = device.isMobile()
  app.device.tablet = device.isTablet()