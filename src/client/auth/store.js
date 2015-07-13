import Form from './form';
import actions from './actions';
import {Record} from 'immutable';

export default function(state, action, payload) {

  switch(action) {

    case 'init':
      // Records allow us to use dot syntax instead of getters everywhere.
      // Aha, record nema set, shit, co s tim?
      return new (Record({
        form: new Form
      }));

    // case actions.login:
    //   return;

    case actions.loginError:
      return state.setIn(['form', 'error'], payload);

    // case action.updateFormField:
    //   return state.setIn(['form', 'fields', payload.name], payload.value);

  }

}
