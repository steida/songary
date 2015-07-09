// import actions from './actions';

// export default {

//   [actions.authError]: (state, error) =>
//     state.setIn(['form', 'error'], error),

//   [actions.updateFormField]: (state, {name, value}) =>
//     state.setIn(['form', 'fields', name], value);

// }

import * as actions from './actions';
import {authCursor} from '../state';
import {register} from '../dispatcher';

export const dispatchToken = register(({action, data}) => {

  switch (action) {
    case actions.authError:
      authCursor(auth => {
        const error = data;
        return auth.setIn(['form', 'error'], error);
      });
      break;

    case actions.updateFormField:
      authCursor(auth => {
        const {name, value} = data;
        return auth.setIn(['form', 'fields', name], value);
      });
      break;
  }

});
