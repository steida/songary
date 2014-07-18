goog.provide 'app.device'

goog.require 'goog.dom.classlist'
goog.require 'goog.labs.userAgent.device'

# PATTERN(steida): Set class asap.
do ->
  classlist = goog.dom.classlist
  device = goog.labs.userAgent.device
  html = document.documentElement

  classlist.enable html, 'is-desktop', device.isDesktop()
  classlist.enable html, 'is-mobile', device.isMobile()
  classlist.enable html, 'is-tablet', device.isTablet()