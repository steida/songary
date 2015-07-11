import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import immutable from 'immutable';
import {Link} from 'react-router';
import {msg} from '../intl/store';

export default class Home extends Component {

  static propTypes = {
    users: React.PropTypes.instanceOf(immutable.Map).isRequired
  }

  render() {
    // const {users: {viewer}} = this.props;
    const viewer = null
    const loginOrMePageLink = viewer
      ? <Link to="me">me</Link>
      : <Link to="login">login</Link>;

    return (
      <DocumentTitle title={msg('home.title')}>
        <div className="home-page">
          <h1>{msg('home.title')}</h1>
          <p>
            Your app here.
          </p>
          {loginOrMePageLink}
        </div>
      </DocumentTitle>
    );
  }

}
