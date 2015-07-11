import './login.styl';
import * as actions from './actions';
import Component from '../components/component.react';
import React from 'react';
import exposeRouter from '../components/exposerouter.react';
import immutable from 'immutable';
// import {Alert, Field} from '../components/bs';
import {Alert} from '../components/bs';
import {focusInvalidField} from '../lib/validation';
import {msg} from '../intl/store';

@exposeRouter
class Login extends Component {

  // static propTypes = {
  //   authLegend: React.PropTypes.string,
  //   form: React.PropTypes.instanceOf(immutable.Record).isRequired,
  //   nextPath: React.PropTypes.string,
  //   pendingActions: React.PropTypes.instanceOf(immutable.Map).isRequired,
  //   router: React.PropTypes.func
  // };

  // onFormSubmit(e) {
  //   e.preventDefault();
  //   this.login('email', this.props.form.fields);
  // }

  redirectAfterLogin() {
    const {router} = this.props;
    const nextPath = router.getCurrentQuery().nextPath;
    router.replaceWith(nextPath || '/');
  }

  login(provider, params) {
    // TODO: this.props.actions.auth.login
    actions.login(provider, params)
      .then(() => this.redirectAfterLogin())
      .catch(focusInvalidField(this));
  }

  // onEmailKeyDown(e) {
  //   if (e.key === 'Escape' && this.props.form.forgetPasswordShown)
  //     actions.toggleForgetPasswordShown();
  // }

  // signup() {
  //   actions.signup(this.props.form.fields)
  //     .then(() => this.redirectAfterLogin())
  //     .catch(focusInvalidField(this));
  // }

  render() {
    return <div>login fok</div>
    const {form, pendingActions} = this.props;
    const pending =
      pendingActions.has(actions.login.toString()) ||
      pendingActions.has(actions.signup.toString()) ||
      pendingActions.has(actions.resetPassword.toString());

    return (
      <div className="login">
        <h1>{msg('auth.title')}</h1>
        <fieldset disabled={pending}>
          <button
            children="Facebook"
            className="btn btn-default"
            onClick={() => this.login('facebook')}
            type="button"
          />
        </fieldset>
        <form noValidate="true" onSubmit={(e) => this.onFormSubmit(e)}>
          {/*
          <fieldset disabled={pending}>
            <legend>{msg('auth.title')}</legend>
            <Field
              error={form.error}
              name="email"
              onChange={actions.updateFormField}
              onKeyDown={(e) => this.onEmailKeyDown(e)}
              placeholder={msg('auth.emailForm.placeholder.email')}
              ref="email"
              value={form.fields.email}
            />
            <Field
              error={form.error}
              name="password"
              onChange={actions.updateFormField}
              placeholder={msg('auth.emailForm.placeholder.password')}
              type="password"
              value={form.fields.password}
            />
            <div className="btn-group" role="group">
              <button
                children={msg('auth.emailForm.button.login')}
                className="btn btn-default"
              />
              <button
                children={msg('auth.emailForm.button.signUp')}
                className="btn btn-default"
                onClick={() => this.signup()}
                type="button"
              />
            </div>
          </fieldset>
          */}
          {form.error &&
            <Alert children={form.error.message} type="danger" />
          }
        </form>
      </div>
    );
  }

}

export default Login;
