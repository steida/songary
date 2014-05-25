goog.provide 'server.FrontPage'

class server.FrontPage

  ###*
    @param {server.react.App} reactApp
    @param {boolean} isDev
    @param {number} buildNumber
    @param {Object} clientData
    @constructor
  ###
  constructor: (@reactApp, @isDev, @buildNumber, @clientData) ->

  ###*
    @param {string} title
    @param {function(): React.ReactComponent} reactComponent
    @return {string} Rendered HTML.
  ###
  render: (title, reactComponent) ->
    html = React.renderComponentToStaticMarkup @reactApp.create
      bodyHtml: @getBodyHtml reactComponent
      buildNumber: @buildNumber
      isDev: @isDev
      title: title

    # React can't render doctype so we have to manually add it.
    '<!DOCTYPE html>' + html

  ###*
    @param {function(): React.ReactComponent} reactComponent
    @return {string}
  ###
  getBodyHtml: (reactComponent) ->
    html = React.renderComponentToString reactComponent()
    html += """
      <script src="#{'/app/client/build/app.js?v=' + @buildNumber}"></script>
    """
    if @isDev
      html += """
        <script src="/bower_components/closure-library/closure/goog/base.js"></script>
        <script src="/tmp/deps.js"></script>
        <script src="/app/client/js/main.js"></script>
        <script src="http://localhost:35729/livereload.js"></script>
      """
    html += """
      <script>app.main(#{JSON.stringify @clientData});</script>
    """
    html