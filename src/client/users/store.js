import User from './user';
import authActions from '../auth/actions';
import {Map} from 'immutable';

// TODO: Check hot load. Doesn't work not, because store is still requested
// somewhere.
export default function (state, action, payload) {

  switch(action) {

    case 'init':
      // TODO: Create record.
      return state.merge({
        map: Map(),
        viewer: null
      });

    case authActions.loggedIn:
      return loggedIn(state, payload);

  }

}

function loggedIn(state, payload) {
  const user = User.fromAuth(payload);
  return state
    .setIn(['map', user.id], user)
    .set('viewer', user);
}
