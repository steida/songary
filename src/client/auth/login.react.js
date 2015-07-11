import './login.styl';
import Component from '../components/component.react';
import React from 'react';
import exposeRouter from '../components/exposerouter.react';
import {Alert} from '../components/bs';
import {Record} from 'immutable';
import {focusInvalidField} from '../lib/validation';

const msg = msg => msg;

@exposeRouter
class Login extends Component {

  static propTypes = {
    actions: React.PropTypes.instanceOf(Record).isRequired,
    form: React.PropTypes.instanceOf(Record).isRequired,
    router: React.PropTypes.func
  };

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
    this.props.actions.login(provider, params)
    //   .then(() => this.redirectAfterLogin())
    //   .catch(focusInvalidField(this));
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
    const {form} = this.props;
    const pending = false;
      // pendingActions.has(actions.login.toString()) ||
      // pendingActions.has(actions.signup.toString()) ||
      // pendingActions.has(actions.resetPassword.toString());

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
