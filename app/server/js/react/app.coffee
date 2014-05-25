goog.provide 'server.react.App'

class server.react.App

  ###*
    @constructor
  ###
  constructor: ->
    {html,head,meta,title,link,script,body} = React.DOM

    @create = React.createClass
      render: ->
        html lang: 'en',
          head null,
            meta charSet: 'utf-8'
            meta name: 'viewport', content: 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'
            title null, this.props.title
            link href: '/app/client/img/favicon.ico', rel: 'shortcut icon'
            link href: '/app/client/build/app.css?v=' + this.props.buildNumber, rel: 'stylesheet'
            script src: '/app/client/build/app.js?v=' + this.props.buildNumber
            this.props.isDev && [
              '/bower_components/closure-library/closure/goog/base.js'
              '/tmp/deps.js'
              '/app/client/js/main.js'
            ].map (src, i) -> script src: src, key: i
          body dangerouslySetInnerHTML: __html: this.props.bodyHtml