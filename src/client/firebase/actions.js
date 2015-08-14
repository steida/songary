import invariant from 'invariant';

export const actions = create();
export const feature = 'firebase';

export function create(dispatch, validate, firebase) {

  function maybeListenFirebaseRef(decorator, getArgs) {
    const {props} = decorator;
    const {action, granular, lazy, ref} = getArgs(props, firebase.root);
    invariant(typeof action === 'function', 'listenFirebase action must be a function.');
    invariant(typeof ref === 'object', 'listenFirebase ref must be a object.');

    if (decorator.ref) {
      // Ref can be changed, especially when url has been changed.
      const refChanged = decorator.ref.toString() !== ref.toString();
      if (!refChanged) return;
      decorator.ref.off();
    }
    if (lazy && lazy()) return;
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
        // Do we need it? I don't think so.
        // setTimeout(() => {
        action(...[...args, props, eventType]);
        // }, 0)
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
      if (decorator.ref)
        decorator.ref.off();
    }

  };

}
