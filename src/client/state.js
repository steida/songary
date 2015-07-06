import State from './lib/state';
import reviveAuth from './auth/revive';
import reviveUsers from './users/revive';

const initialState = process.env.IS_BROWSER
  ? window._appState
  : require('../server/initialstate');

export const appState = new State(initialState, function(key, value) {
  switch (key) {
    case 'auth': return reviveAuth(value);
    case 'users': return reviveUsers(value);
  }
});

export const authCursor = appState.cursor(['auth']);
export const firebaseCursor = appState.cursor(['firebase']);
export const i18nCursor = appState.cursor(['i18n']);
export const pendingActionsCursor = appState.cursor(['pendingActions']);
export const usersCursor = appState.cursor(['users']);
