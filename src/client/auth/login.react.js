import './login.styl';
import Component from '../components/component.react';
import React from 'react';
import {focusInvalidField} from '../lib/validation';

export default class Login extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    auth: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired
  };

  onFormSubmit(e) {
    e.preventDefault();
    this.login({signUp: false});
  }

  login({signUp}) {
    const {actions: {auth}, auth: {form}} = this.props;
    const action = signUp ? auth.signUp : auth.login;
    action(form.fields)
      .catch(focusInvalidField(this));
  }

  render() {
    const {
      actions: {auth: actions},
      auth: {form},
      msg: {auth: {form: msg}}
    } = this.props;

    return (
      <div className="login">
        <form onSubmit={::this.onFormSubmit}>
          <fieldset disabled={form.disabled}>
            <legend>{msg.legend}</legend>
            <input
              autoFocus
              name="email"
              onChange={actions.setFormField}
              placeholder={msg.placeholder.email}
              value={form.fields.email}
            />
            <br />
            <input
              name="password"
              onChange={actions.setFormField}
              placeholder={msg.placeholder.password}
              type="password"
              value={form.fields.password}
            />
            <br />
            <button
              children={msg.button.login}
              type="submit"
            />
            <button
              children={msg.button.signUp}
              onClick={() => this.login({signUp: true})}
              type="button"
            />
            <p>
            {form.error &&
              <span className="error-message">{form.error.message}</span>
            }
            </p>
          </fieldset>
        </form>
      </div>
    );
  }

}
