import * as authActions from '../auth/actions';
import {register} from '../dispatcher';
import User from './user';
import {usersCursor} from '../state';

export const dispatchToken = register(({action, data}) => {

  switch (action) {
    case authActions.loggedIn:
      usersCursor(users => {
        const user = User.fromAuth(data);
        return users
          .setIn(['map', user.id], user)
          .set('viewer', user);
      });
      break;
  }

});

export function isLoggedIn() {
  return !!usersCursor(['viewer']);
}
