import './app.styl';
import Component from '../components/component.react';
import Footer from './footer.react';
import Header from './header.react';
import React from 'react';
import exposeRouter from '../components/exposerouter.react';
import firebase from '../firebase/decorate';
import flux from '../lib/flux';
import store from './store';
import {RouteHandler} from 'react-router';
import {createValidate} from '../validate';

import * as authActions from '../auth/actions';
import * as firebaseActions from '../firebase/actions';
import * as songsActions from '../songs/actions';

const actions = [authActions, firebaseActions, songsActions];

@flux(store)
@firebase
@exposeRouter
export default class App extends Component {

  static propTypes = {
    firebase: React.PropTypes.object,
    flux: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    router: React.PropTypes.func.isRequired,
    users: React.PropTypes.object.isRequired
  };

  constructor(props) {
    super(props);
    this.onFirebaseAuth = ::this.onFirebaseAuth;
  }

  componentWillMount() {
    this.createActions();
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

  createActions() {
    const {firebase, flux, msg, router} = this.props;
    const validate = createValidate(msg);
    // console.log(actions)
    this.actions = actions.reduce((actions, {feature, create}) => {
      const dispatch = (action, payload) => flux.dispatch(action, payload, {feature});
      const featureActions = create(
        dispatch, validate, msg[feature], firebase, router
      );
      return {...actions, [feature]: featureActions};
    }, {});
    // console.log(this.actions)
  }

  onFirebaseAuth(auth) {
    const {users: {viewer}} = this.props;
    if (auth && !viewer)
      this.actions.auth.loginSuccess(auth);
    else if (!auth && viewer)
      this.actions.auth.logout();
  }

  maybeRedirectAfterClientSideAuth() {
    const {firebase: {root}, router} = this.props;
    const auth = root.getAuth();
    const nextPath = router.getCurrentQuery().nextPath;
    if (auth && nextPath)
      router.replaceWith(nextPath);
  }

  render() {
    const props = {...this.props, actions: this.actions};
    const {users: {viewer}, msg, router} = props;
    const songPageIsShown = router.getCurrentPath().indexOf('/me/song') > -1;

    return (
      <div className="page">
        {/* Pass only what's needed. Law of Demeter ftw. */}
        {!songPageIsShown && <Header msg={msg} viewer={viewer} />}
        <RouteHandler {...props} />
        {!songPageIsShown && <Footer msg={msg} />}
      </div>
    );
  }

}
