goog.provide 'server.react.App'

class server.react.App

  ###*
    @constructor
  ###
  constructor: ->
    {html,head,meta,title,link,body} = React.DOM

    @create = React.createClass
      render: ->
        html lang: 'en',
          head null,
            meta charSet: 'utf-8'
            # NOTE(steida): http://www.mobilexweb.com/blog/ios-7-1-safari-minimal-ui-bugs
            meta name: 'viewport', content: 'width=device-width, initial-scale=1.0, minimal-ui, maximum-scale=1.0, user-scalable=no'
            title null, this.props.title
            link href: '/app/client/img/favicon.ico', rel: 'shortcut icon'
            link href: '/app/client/build/app.css?v=' + this.props.version, rel: 'stylesheet'
            # TODO(steida): Base64 inline.
            link href: 'http://fonts.googleapis.com/css?family=PT+Sans&amp;subset=latin,latin-ext', rel: 'stylesheet'
          body dangerouslySetInnerHTML: __html: this.props.bodyHtml