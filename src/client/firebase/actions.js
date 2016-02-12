import invariant from 'invariant';
import {Seq} from 'immutable';

export const actions = create();
export const feature = 'firebase';

export function create(dispatch, validate, firebase) {

  const sameQueries = (q1, q2) => JSON.stringify(q1) === JSON.stringify(q2);

  function createRef(query) {
    const ref = Seq(query).reduce((ref, args, methodName) => {
      if (!methodName) return ref;
      // Ensure args is array.
      args = [].concat(args);
      const method = ref[methodName];
      if (process.env.NODE_ENV !== 'production') {
        invariant(typeof method === 'function',
          `listenFirebase: ${methodName} is not Firebase method.`);
      }
      return method.apply(ref, args);
    }, firebase.root);
    ref.query = query;
    return ref;
  }

  function maybeListenFirebaseRef(decorator, getArgs) {
    const {props} = decorator;
    const {action, granular, lazy, query} = getArgs(props);
    if (process.env.NODE_ENV !== 'production') {
      invariant(typeof action === 'function',
        'listenFirebase: action must be a function.');
      invariant(typeof query === 'object',
        'listenFirebase: query must be a object.');
    }

    if (decorator.ref) {
      if (sameQueries(decorator.ref.query, query)) return;
      decorator.ref.off();
    }
    if (lazy && lazy()) return;

    const ref = createRef(query);
    decorator.ref = ref;
    listen(action, granular, props, ref);
  }

  function listen(action, granular, props, ref) {
    const events = ['value'];
    if (granular) events.push(
      'child_added',
      'child_changed',
      'child_moved',
      'child_removed'
    );
    events.forEach(eventType => {
      ref.on(eventType, (...args) => {
        action(...[...args, props, eventType]);
      }, onFirebaseError);
    });
  }

  function onFirebaseError(error) {
    throw error;
  }

  return {

    onDecoratorDidMount(decorator, getArgs) {
      maybeListenFirebaseRef(decorator, getArgs);
    },

    onDecoratorDidUpdate(decorator, getArgs) {
      maybeListenFirebaseRef(decorator, getArgs);
    },

    onDecoratorWillUnmount(decorator) {
      if (decorator.ref) decorator.ref.off();
    }

  };

}
