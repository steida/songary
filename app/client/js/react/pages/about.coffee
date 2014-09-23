goog.provide 'app.react.pages.About'

goog.require 'goog.ui.Textarea'

class app.react.pages.About

  ###*
    @param {app.user.Store} userStore
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (userStore, firebase) ->
    {div,p,form,textarea,menu,button,a} = React.DOM

    message = ''

    @component = React.createClass

      render: ->
        div className: 'page',
          p {}, About.MSG_ABOUT
          if userStore.isLogged()
            form className: 'contact-form',
              div className: 'form-group',
                textarea
                  autoFocus: true
                  className: 'form-control'
                  onChange: @onContactFormMessageChange
                  placeholder: About.MSG_SEND_PLACEHOLDER
                  ref: 'message'
                  value: message
              button
                className: 'btn btn-default'
                disabled: !message.length
                onClick: @onContactFromSubmit
                type: 'button'
              , About.MSG_SEND_BUTTON_LABEL
          p {},
            a
              href: 'https://github.com/steida/songary/issues'
              target: '_blank'
            , About.MSG_ISSUES

      onContactFormMessageChange: (e) ->
        message = e.target.value.slice 0, 499
        @forceUpdate()

      onContactFromSubmit: ->
        if message.length < 9
          alert @getSuspiciousMessageWarning message
          return
        user = userStore.user
        firebase.sendContactFormMessage user.uid, user.displayName, message
        alert About.MSG_THANK_YOU
        message = ''
        @forceUpdate()

      getSuspiciousMessageWarning: (message) ->
        About.MSG_FOK = goog.getMsg 'Is “{$message}” really what you want to tell us?',
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
