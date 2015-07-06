import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import LoginForm from '../auth/login.react';
import React from 'react';
import immutable from 'immutable';
import {msg} from '../intl/store';

class Login extends Component {

  static propTypes = {
    auth: React.PropTypes.instanceOf(immutable.Map).isRequired
  };

  render() {
    const form = this.props.auth.get('form');

    return (
      <DocumentTitle title={msg('auth.title')}>
        <div className="login-page">
          <LoginForm {...this.props} form={form} />
        </div>
      </DocumentTitle>
    );
  }

}

export default Login;
