import immutable from 'immutable';

import authStore from '../auth/store';
import intlStore from '../intl/store';
import songsStore from '../songs/store';
import usersStore from '../users/store';

export default function appStore(state, action, payload) {
  if (!action) state = immutable.fromJS(state);

  state = state
    .update('auth', (s) => authStore(s, action, payload))
    .update('intl', (s) => intlStore(s, action, payload))
    .update('songs', (s) => songsStore(s, action, payload))
    .update('users', (s) => usersStore(s, action, payload));

  state = state
    .update('msg', (s) => state.get('intl').messages);

  return state;
}
