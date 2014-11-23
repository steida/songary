goog.provide 'app.about.react.Page'

goog.require 'goog.labs.userAgent.device'
goog.require 'goog.ui.Textarea'

class app.about.react.Page

  ###*
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (usersStore, element) ->
    {div, p, form, textarea, menu, button, a} = element

    message = ''

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          p {}, Page.MSG_ABOUT
          # TODO: Migrate to Elastic Search.
          if false && usersStore.isLogged()
            form className: 'contact-form',
              div className: 'form-group',
                textarea
                  autoFocus: goog.labs.userAgent.device.isDesktop()
                  className: 'form-control'
                  onChange: @onContactFormMessageChange
                  placeholder: Page.MSG_SEND_PLACEHOLDER
                  ref: 'message'
                  value: message
              button
                className: 'btn btn-default'
                disabled: !message.trim().length
                onClick: @onContactFromSubmit
                type: 'button'
              , Page.MSG_SEND_BUTTON_LABEL
          p {},
            a
              href: 'https://github.com/steida/songary/issues'
              target: '_blank'
            , Page.MSG_ISSUES

      onContactFormMessageChange: (e) ->
        message = e.target.value.slice 0, 499
        @forceUpdate()

      onContactFromSubmit: ->
        if message.length < 9
          alert @getSuspiciousMessageWarning message
          return
        user = usersStore.user
        # firebase.sendContactFormMessage user.uid, user.displayName, message
        alert Page.MSG_THANK_YOU
        message = ''
        @forceUpdate()

      getSuspiciousMessageWarning: (message) ->
        Page.MSG_FOK = goog.getMsg 'Is “{$message}” really what you want to tell us?',
          message: message

      componentDidMount: ->
        @messageTextarea = new goog.ui.Textarea ''
        el = @refs['message']?.getDOMNode()
        @messageTextarea.decorate el if el

      componentWillUnmount: ->
        @messageTextarea.dispose()

  @MSG_ABOUT: goog.getMsg 'Songary. Your songbook.'
  @MSG_ISSUES: goog.getMsg 'Songary issues on Github'
  @MSG_SEND_BUTTON_LABEL: goog.getMsg 'Let Us Know'
  @MSG_SEND_PLACEHOLDER: goog.getMsg 'Compliments, complaints, or suggestions.'
  @MSG_THANK_YOU: goog.getMsg 'Thank you.'
