import {Record} from 'immutable';

const UserRecord = Record({
  email: '',
  id: '',
  provider: ''
});

export default class User extends UserRecord {

  // TODO: Add Facebook, Twitter, Google, Github.
  static fromFirebaseAuth(auth) {
    const id = auth.auth.uid;
    const {provider} = auth;
    const {email} = auth[provider];
    return new User({email, id, provider});
  }

}
