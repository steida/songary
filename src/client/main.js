import React from 'react';
import Router from 'react-router';
import routes from './routes';
import {init as firebaseInit} from './firebase';
import {isLoggedIn} from './users/store';
import {loggedIn} from './auth/actions';
import {measureRender} from './console';

firebaseInit(loggedIn, isLoggedIn);

// Never render to body. Everybody updates it.
// https://medium.com/@dan_abramov/two-weird-tricks-that-fix-react-7cf9bbdef375
const app = document.getElementById('app');

Router.run(routes, Router.HistoryLocation, (Handler) => {
  measureRender(done => React.render(<Handler />, app, done));
});
