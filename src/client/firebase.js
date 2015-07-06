import Firebase from 'firebase';
import Promise from 'bluebird';
import {ValidationError} from './lib/validation';
import {firebaseCursor} from './state';

// if (!process.env.IS_BROWSER) {
//   // TODO: Set Firebase for server.
// }

export const TIMESTAMP = Firebase.ServerValue.TIMESTAMP;
export const firebase = new Firebase(firebaseCursor().get('url'));

// Explicitly passed loggedIn and isLoggedIn to prevent circular dependencies.
export function init(loggedIn, isLoggedIn) {
  // Sync getAuth for asap rendering.
  const authData = firebase.getAuth();
  if (authData)
    loggedIn(authData);
  firebase.onAuth((authData) => {
    // Just loggedIn.
    if (authData && !isLoggedIn())
      loggedIn(authData);
    else if (!authData && isLoggedIn())
      location.href = '/';
  });
}

// Promisify Firebase onComplete callback.
export function promisify(callback: Function) {
  return new Promise((resolve, reject) => {
    // On failure, the first argument will be an Error object indicating the
    // failure, with a machine-readable code attribute. On success, the first
    // argument will be null and the second can be an object containing result.
    callback((error, data) => {
      if (error) {
        reject(error);
        return;
      }
      resolve(data);
    });
  });
}

function change(method: string, path: Array<string>, data) {
  const child = firebase.child(path.join('/'));
  return promisify(onComplete => {
    const args = Array.prototype.slice.call(arguments, 2).concat(onComplete);
    child[method].apply(child, args);
  });
}

export function set(path: Array<string>, data): Promise {
  return change('set', path, data);
}

export function push(path: Array<string>, data): Promise {
  return change('push', path, data);
}

export function update(path: Array<string>, data): Promise {
  return change('update', path, data);
}

export function remove(path: Array<string>): Promise {
  return change('remove', path);
}

export function hasFirebaseErrorCode(error) {
  const codes = [
    'AUTHENTICATION_DISABLED',
    'EMAIL_TAKEN',
    'INVALID_ARGUMENTS',
    'INVALID_CONFIGURATION',
    'INVALID_CREDENTIALS',
    'INVALID_EMAIL',
    'INVALID_ORIGIN',
    'INVALID_PASSWORD',
    'INVALID_PROVIDER',
    'INVALID_TOKEN',
    'INVALID_USER',
    'NETWORK_ERROR',
    'PROVIDER_ERROR',
    'TRANSPORT_UNAVAILABLE',
    'UNKNOWN_ERROR',
    'USER_CANCELLED',
    'USER_DENIED'
  ];
  return codes.indexOf(error.code) !== -1;
}

export function firebaseValidationError(error) {
  if (!hasFirebaseErrorCode(error))
    return error;
  // Heuristic field detection.
  const prop = error.message.indexOf('password') > -1 ? 'password' : 'email';
  // Transform Firebase error to ValidationError.
  return new ValidationError(error.message, prop);
}

export function onFirebaseError(error) {
  throw error;
}

export function ensureId(value, id: ?string) {
  // It's ok to override Firebase data.
  if (id) {
    if (value) value.id = id;
    return value;
  }
  for (let id in value) value[id].id = id;
  return value;
}

// Firebase key can't contain URL specific chars.
// http://stackoverflow.com/questions/24412393/how-to-index-by-email-in-firebase
// http://jsfiddle.net/katowulf/HLUc5/
// https://groups.google.com/forum/#!topic/firebase-talk/vtX8lfxxShk
export function escapeEmail(email) {
  return email.replace(/\./g, ',');
}

export function unescapeEmail(email) {
  return email.replace(/\,/g, '.');
}

export function encodeKey(uri) {
  return encodeURIComponent(uri).replace(/\./g, '%2E');
}

export function decodeKey(uri) {
  return decodeURIComponent(uri);
}

export function once(eventType, path: Array<string>) {
  return new Promise((resolve, reject) => {
    firebase
      .child(path.join('/'))
      .once(eventType, resolve, reject);
  });
}
