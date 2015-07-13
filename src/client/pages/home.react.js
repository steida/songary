import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import {Link} from 'react-router';
import {msg} from '../intl/store';

export default class Home extends Component {

  static propTypes = {
    // No need to specify record if we have dot syntax.
    users: React.PropTypes.object.isRequired
  }

  render() {
    const {users: {viewer}} = this.props;
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
