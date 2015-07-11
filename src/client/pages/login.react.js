import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import LoginForm from '../auth/login.react';
import React from 'react';
import {Record} from 'immutable';
// import {msg} from '../intl/store';

const msg = msg => msg;

export default class Login extends Component {

  static propTypes = {
    auth: React.PropTypes.instanceOf(Record).isRequired
  }

  render() {
    const {actions, auth} = this.props;
    return (
      // TODO: title={this.props.messages.auth.title}
      <DocumentTitle title={msg('auth.title')}>
        <div className="login-page">
          <LoginForm actions={actions.auth} form={auth.form} />
        </div>
      </DocumentTitle>
    );
  }

}
