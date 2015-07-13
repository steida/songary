import User from './user';
import authActions from '../auth/actions';
import {Map, Record} from 'immutable';

// TODO: Check hot load. Doesn't work not, because store is still requested
// somewhere.
export default function (state, action, payload) {

  switch(action) {

    case 'init':
      return new (Record({
        map: Map(),
        viewer: null
      }));

    case authActions.login:
      console.log(payload)
      return login(state, payload);

  }

}

function login(state, payload) {
  const user = User.fromAuth(payload);
  return state
    .setIn(['map', user.id], user)
    .set('viewer', user);
}
