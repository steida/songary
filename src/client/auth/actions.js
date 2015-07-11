import User from '../users/user';
import {firebase, promisify, firebaseValidationError, set} from '../firebase';
import {validate} from '../validation';

// Export actions as default object, because indentation nicely separates public
// and private functions. Exporting plain functions separately is verbose and
// doesn't makes sense.
export default {

  updateFormField({target: {name, value}}) {
    // Both email and password max length is 256.
    value = value.slice(0, 256);
    // I don't like returning {type: 'foo', ...}, because it can clash with
    // payload type property. Therefore, Este prefers returning object instead.
    // This allows returning primitive objects as well. Also, typing type twice
    // is verbose. Hint, function name itself is action type.
    return {name, value};
  },

  login(provider, params) {
    // Because Firebase is control freak requiring plain JS object.
    if (params) params = params.toJS();
    return providerLogin(provider, params)
      .then(saveUser)
      .catch(error => {
        error = firebaseValidationError(error);
        this.authError(error);
        throw error;
      });
  },

  authError(error) {
    return error;
  },

  loggedIn(authData) {
    return authData;
  },

  logout() {
    firebase.unauth();
  },

  toggleForgetPasswordShown() {},

  resetPassword(params) {
    return validate(params)
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
      });
  },

  signup(params) {
    // if (params) params = params.toJS(); // wtf?
    // return validateForm(params)
    //   .then(() => {
    //     return promisify(onComplete => {
    //       firebase.createUser(params, onComplete);
    //     });
    //   })
    //   .then(() => authWithPassword(params))
    //   .then(saveUser)
    //   .catch(error => {
    //     error = firebaseValidationError(error);
    //     authError(error);
    //     throw error;
    //   });
  }

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
