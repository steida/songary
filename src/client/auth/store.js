import Form from './form';
import {Record} from 'immutable';
import {actions} from './actions';

// We can use simple initialState if no data from server need to be revived.
const initialState = new (Record({
  form: new Form,
  fok: 1
}));

const disableForm = (state, disable) =>
  state.setIn(['form', 'disabled'], disable);

export default function(state = initialState, action, payload) {

  switch (action) {

    case actions.login:
    case actions.signUp:
      return disableForm(state, true);

    case actions.loginFail:
    case actions.signUpFail:
      return disableForm(state, false).setIn(['form', 'error'], payload);

    case actions.loginSuccess:
      return disableForm(state, false).setIn(['form', 'error'], null);

    case actions.setFormField:
      return state.setIn(['form', 'fields', payload.name], payload.value);

  }

  return state;
}
