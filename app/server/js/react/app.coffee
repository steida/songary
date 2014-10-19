goog.provide 'server.react.App'

goog.require 'goog.labs.userAgent.device'

class server.react.App

  ###*
    @constructor
  ###
  constructor: ->
    {html,head,meta,title,link,body} = React.DOM

    @component = React.createFactory React.createClass
      render: ->
        html lang: 'en', className: @getHtmlClassName(),
          head {},
            meta charSet: 'utf-8'
            meta name: 'viewport', content: 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'
            title {}, this.props.title
            link href: '/app/client/img/favicon.ico?v=' + this.props.version, rel: 'shortcut icon'
            link href: '/app/client/build/app.css?v=' + this.props.version, rel: 'stylesheet'
          body dangerouslySetInnerHTML: __html: this.props.bodyHtml

      getHtmlClassName: ->
        # PATTERN: Favor CSS media queries over this classes. But sometime
        # html:not(.is-desktop) is more handy.
        React['addons']['classSet']
          'is-mobile': goog.labs.userAgent.device.isMobile()
          'is-tablet': goog.labs.userAgent.device.isTablet()
          'is-desktop': goog.labs.userAgent.device.isDesktop()
