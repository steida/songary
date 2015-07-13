import './app.styl';
import Component from '../components/component.react';
import React from 'react';
import exposeRouter from '../components/exposerouter.react';
import flux from '../lib/flux';
import {RouteHandler} from 'react-router';

import authActions from '../auth/actions';
import authStore from '../auth/store';
import usersStore from '../users/store';

// Compose actions, stores, and app state declaratively.
@flux({
  auth: [authActions, authStore],
  users: [usersStore]
})
@exposeRouter
// @firebase?
export default class App extends Component {

  static propTypes = {
    router: React.PropTypes.func,
    users: React.PropTypes.object.isRequired
  }

  componentWillMount() {
    if (!process.env.IS_BROWSER) return;
    this.redirectAfterClientSideAuth();
  }

  // For client auth, when server redirects user to login path. If user is
  // authenticated on client, then this method redirect him back.
  redirectAfterClientSideAuth() {
    const {router, users} = this.props;
    const isLoggedIn = !!users.viewer;
    const nextPath = router.getCurrentQuery().nextPath;
    if (nextPath && isLoggedIn) router.replaceWith(nextPath);
  }

  render() {
    const test = this.props.auth.test;
    // this.props.actions.auth.login atd.
    // this.props.flux.getState, setState. .on

    return (
      <div className="page">
        <h1>{test}</h1>
        {/*<Header isLoggedIn={this.state.isLoggedIn} />*/}
        <RouteHandler {...this.props} />
        {/*<Footer />*/}
      </div>
    );
  }

}
