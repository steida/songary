import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import {Link} from 'react-router';
import {msg} from '../intl/store';

class Home extends Component {

  static propTypes = {
    isLoggedIn: React.PropTypes.bool.isRequired
  };

  render() {
    const {isLoggedIn} = this.props;
    const loginOrMePageLink = isLoggedIn
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

export default Home;
