goog.provide 'app.react.Validation'

goog.require 'app.errors.ValidationError'
goog.require 'este.dom'

class app.react.Validation

  ###*
    TODO: Show something better than alert. Consider validation.form helper.
    TODO: Move to este-library once finished.
    @constructor
  ###
  constructor: ->

    @mixin =
      validate: (promise) ->
        promise.thenCatch (reason) =>
          # Don't swallow other errors.
          if reason not instanceof app.errors.ValidationError
            throw reason

          error = reason.errors[0]
          alert error.msg

          prop = error.props[0]
          return if !prop
          form = @refs['form']
          if !form && goog.DEBUG
            console.log "app.react.Validation: Please add ref: 'form' to form element."
            return
          este.dom.focusAsync form.getDOMNode().elements[prop]
