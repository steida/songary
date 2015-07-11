import EventEmitter from 'eventemitter3';
import immutable from 'immutable';

export default class Flux extends EventEmitter {

  constructor(initialState) {
    super();
    this._state = immutable.fromJS(initialState);
  }

  getState() {
    return this._state;
  }

  getStateForAppComponent() {
    // Shallowly convert state map to an Object to project features.
    return this._state.toObject();
  }

}


// import Flux from '../client/lib/flux';
// // import authActions from '../auth/actions';
// // import authStore from '../auth/store';
// // import usersActions from '../users/actions';
// // import usersStore from '../users/store';


// export default new Flux(initialState, {
//   auth: [authActions, authStore],
//   users: [usersActions, usersStore],
//   todos: [todosActions, todosStore]
// });

// // getState, onStateChange, createActions?

