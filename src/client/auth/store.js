import Form from './form';
import actions from './actions';
import {Record} from 'immutable';

// Pure side effects free function. That's what functional Flux is all about.
export default function(state, action, payload) {

  switch(action) {

    case 'init':
      // Records allow us to use dot syntax instead of getters everywhere.
      return new (Record({
        form: new Form
      }));

    case actions.authError:
      return state.setIn(['form', 'error'], payload);

    // case action.updateFormField:
    //   return state.setIn(['form', 'fields', payload.name], payload.value);

  }

}
