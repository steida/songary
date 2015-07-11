import Form from './form';
import actions from './actions';

export default function(state, action, payload) {

  switch(action) {

    // TODO: or actions.initStore?
    case 'init':
      return state.merge({
        form: new Form,
        // TODO: Try to update it, and see how hot load is working :-)
        test: 1
      });

    case actions.authError:
      return state.setIn(['form', 'error'], payload);

    case action.updateFormField:
      return state.setIn(['form', 'fields', payload.name], payload.value);

  }

}
