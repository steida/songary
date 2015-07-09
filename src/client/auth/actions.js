import User from '../users/user';
import setToString from '../lib/settostring';
import {dispatch} from '../dispatcher';
import {firebase, promisify, firebaseValidationError, set} from '../firebase';
import {validate} from '../validation';

// export default {

//   updateFormField({target: {name, value}}) {
//     // Both email and password max length is 256.
//     value = value.slice(0, 256);
//     return {name, value};
//   },

//   login(provider, params) {
//     // Because Firebase is control freak requiring plain JS object.
//     if (params) params = params.toJS();
//     return providerLogin(provider, params)
//       .then(saveUser)
//       .catch(error => {
//         error = firebaseValidationError(error);
//         authError(error);
//         throw error;
//       });
//   }

// }

export function updateFormField({target: {name, value}}) {
  // Both email and password max length is 256.
  value = value.slice(0, 256);
  dispatch(updateFormField, {name, value});
}

export function login(provider, params) {
  // Because Firebase is control freak requiring plain JS object.
  if (params) params = params.toJS();
  return dispatch(login, providerLogin(provider, params)
    .then(saveUser)
    .catch(error => {
      error = firebaseValidationError(error);
      authError(error);
      throw error;
    })
  );
}

export function authError(error) {
  dispatch(authError, error);
}

export function loggedIn(authData) {
  dispatch(loggedIn, authData);
}

export function logout() {
  firebase.unauth();
}

export function toggleForgetPasswordShown() {
  dispatch(toggleForgetPasswordShown);
}

export function resetPassword(params) {
  return dispatch(resetPassword, validate(params)
    .prop('email').required().email()
    .promise
      .then(() => {
        return promisify(onComplete => {
          firebase.resetPassword(params, onComplete);
        });
      })
      .catch(error => {
        error = firebaseValidationError(error);
        authError(error);
        throw error;
      }));
}

export function signup(params) {
  if (params) params = params.toJS();
  return dispatch(signup, validateForm(params)
    .then(() => {
      return promisify(onComplete => {
        firebase.createUser(params, onComplete);
      });
    })
    .then(() => authWithPassword(params))
    .then(saveUser)
    .catch(error => {
      error = firebaseValidationError(error);
      authError(error);
      throw error;
    }));
}

function providerLogin(provider, params) {
  return provider === 'email'
    ? emailLogin(params)
    : socialLogin(provider);
}

function emailLogin(params) {
  return validateForm(params)
    .then(() => authWithPassword(params));
}

function validateForm(params) {
  return validate(params)
    .prop('email').required().email()
    .prop('password').required().simplePassword()
    .promise;
}

function authWithPassword(params) {
  return promisify(onComplete => {
    firebase.authWithPassword(params, onComplete);
  });
}

// Never merge social accounts. Never treat email as key.
// http://grokbase.com/p/gg/firebase-talk/14a91gqjse/firebase-handling-multiple-providers
function socialLogin(provider) {
  return promisify(onComplete => {
    const options = {
      scope: {
        facebook: 'email,user_friends',
        google: 'email',
        twitter: ''
      }[provider]
    };
    // https://www.firebase.com/docs/web/guide/user-auth.html#section-popups
    firebase.authWithOAuthPopup(provider, (error, authData) => {
      if (error && error.code === 'TRANSPORT_UNAVAILABLE') {
        firebase.authWithOAuthRedirect(provider, onComplete, options);
        return;
      }
      onComplete(error, authData);
    }, options);
  });
}

function saveUser(auth) {
  const user = User.fromAuth(auth);
  return set(['users', user.id], user.toJS());
}

setToString('auth', {
  authError,
  loggedIn,
  login,
  logout,
  resetPassword,
  signup,
  toggleForgetPasswordShown,
  updateFormField
});
