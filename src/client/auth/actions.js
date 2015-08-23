import User from '../users/user';

export const actions = create();
export const feature = 'auth';

// const formFieldMaxLength = 100;

export function create(dispatch, validate, firebase, router) {

  // const validateForm = fields => validate(fields)
  //   .prop('email').required().email()
  //   .prop('password').required().simplePassword()
  //   .promise;

  function saveUser(auth) {
    const user = User.fromFirebaseAuth(auth);
    return firebase.set(['users', user.id], user.toJS())
      .then(() => auth);
  }

  function redirectAfterAuth() {
    const nextPath = router.getCurrentQuery().nextPath;
    router.replaceWith(nextPath || 'me');
  }

  return {

    auth(provider) {
      // TODO: Add email, github, and twitter providers once merging account
      // will be implemented.

      const options = {
        scope: {
          facebook: 'email,user_friends',
          google: 'email',
          twitter: '' // email must be requested ad hoc
        }[provider]
      };

      dispatch(actions.auth, {provider, options});
      firebase.authWithOAuth(provider, options)
        .then((auth) => saveUser(auth))
        .then(() => redirectAfterAuth())
        .then(() => dispatch(actions.authSuccess))
        .catch(e => dispatch(actions.authFail, e));
    },
    authSuccess() {},
    authFail() {},

    // Is called by Firebase onAuth.
    onAuth(auth) {
      dispatch(actions.onAuth, {auth});
    },

    // TODO: Email login and sign up must be revisited to merge various social
    // providers with Firebase email.
    // login(fields) {
    //   dispatch(actions.login);
    //   return validateForm(fields)
    //     .then(() => firebase.authWithPassword(fields.toJS()))
    //     .then((auth) => {
    //       redirectAfterAuth();
    //       return auth;
    //     })
    //     .then((auth) => saveUser(auth))
    //     .catch(error => {
    //       dispatch(actions.loginFail, error);
    //       throw error;
    //     });
    // },
    // // Is called by Firebase onAuth.
    // loginSuccess(auth) {
    //   return dispatch(actions.loginSuccess, auth);
    // },
    // loginFail() {},

    // signUp(fields) {
    //   dispatch(actions.signUp);
    //   return validateForm(fields)
    //     .then(() => firebase.createUser(fields.toJS()))
    //     // TODO: This is almost the same as login flow, refactor.
    //     .then(() => firebase.authWithPassword(fields.toJS()))
    //     .then((auth) => {
    //       redirectAfterAuth();
    //       return auth;
    //     })
    //     .then((auth) => saveUser(auth))
    //     .catch(error => {
    //       dispatch(actions.signUpFail, error);
    //       throw error;
    //     });
    // },
    // signUpSuccess() {},
    // signUpFail() {},

    logout() {
      firebase.unauth();
    }

    // setFormField({target: {name, value}}) {
    //   value = value.slice(0, formFieldMaxLength);
    //   dispatch(actions.setFormField, {name, value});
    // }

  };

}
