// import Footer from './footer.react';
// import Header from './header.react';
import './app.styl';
import Component from '../components/component.react';
import React from 'react';
import exposeRouter from '../components/exposerouter.react';
import {RouteHandler} from 'react-router';
import {appState} from '../state';
import {isLoggedIn} from '../users/store';
import {measureRender} from '../console';

// All stores must be imported here.
import '../auth/store';
import '../users/store';

@exposeRouter
class App extends Component {

  static propTypes = {
    router: React.PropTypes.func
  };

  constructor(props) {
    super(props);
    this.state = this.getState();
  }

  getState() {
    const viewer = appState.get().getIn(['users', 'viewer']);
    return appState.get().merge({
      isLoggedIn: isLoggedIn(),
      viewer: viewer
    }).toObject();
  }

  // Why componentWillMount instead of componentDidMount.
  // https://github.com/este/este/issues/274
  componentWillMount() {
    if (!process.env.IS_BROWSER) return;
    appState.on('change', () => {
      measureRender(done => this.setState(this.getState(), done));
    });
    // This is for client based auths like Firebase. Server redirects unauth
    // user to login path defined in requireAuth. If this.state.isLoggedIn
    // equals true and next path is defined, redirect user to original page.
    this.redirectAfterClientSideAuth();
  }

  redirectAfterClientSideAuth() {
    const {router} = this.props;
    const nextPath = router.getCurrentQuery().nextPath;
    if (nextPath && this.state.isLoggedIn)
      router.replaceWith(nextPath);
  }

  render() {
    return (
      <div className="page">
        {/*<Header isLoggedIn={this.state.isLoggedIn} />*/}
        <RouteHandler {...this.state} />
        {/*<Footer />*/}
      </div>
    );
  }

}

export default App;
