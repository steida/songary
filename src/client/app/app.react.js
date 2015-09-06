import './app.styl';
import Component from '../components/component.react';
import Footer from './footer.react';
import Header from './header.react';
import React from 'react';
import createActions from './createactions';
import exposeRouter from '../components/exposerouter';
import firebase from '../firebase/decorate';
import flux from '../lib/flux';
import store from './store';
import {RouteHandler} from 'react-router';

@flux(store)
@firebase
@createActions
@exposeRouter
export default class App extends Component {

  static propTypes = {
    firebase: React.PropTypes.object,
    msg: React.PropTypes.object.isRequired,
    router: React.PropTypes.func.isRequired,
    users: React.PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);
    this.onFirebaseAuth = ::this.onFirebaseAuth;
  }

  componentWillMount() {
    if (!process.env.IS_BROWSER) return;
    const {firebase: {root}} = this.props;
    root.onAuth(this.onFirebaseAuth);
  }

  componentDidMount() {
    // When server did not recognize logged in user, it will redirect to
    // login form. But if then client recognize user, app should redirect back
    // to required path.
    this.maybeRedirectAfterClientSideAuth();
  }

  componentWillUnmount() {
    const {firebase: {root}} = this.props;
    root.offAuth(this.onFirebaseAuth);
  }

  onFirebaseAuth(auth) {
    const {actions, users: {viewer}} = this.props;
    if (auth && !viewer)
      actions.auth.onAuth(auth);
    else if (!auth && viewer)
      actions.auth.logout();
  }

  maybeRedirectAfterClientSideAuth() {
    const {firebase: {root}, router} = this.props;
    const auth = root.getAuth();
    const nextPath = router.getCurrentQuery().nextPath;
    if (auth && nextPath)
      router.replaceWith(nextPath);
  }

  render() {
    const {users: {viewer}, msg, router} = this.props;
    const routes = router.getCurrentRoutes();
    const currentRoute = routes[routes.length - 1];
    const songPageIsShown = currentRoute.name === 'song';

    return (
      <div className="page">
        {!songPageIsShown && <Header msg={msg} viewer={viewer} />}
        <RouteHandler {...this.props} />
        {!songPageIsShown && <Footer msg={msg} />}
      </div>
    );
  }

}
