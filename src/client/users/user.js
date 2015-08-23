import {Record} from 'immutable';

const UserRecord = Record({
  displayName: '',
  email: '',
  facebook: null, // todo: email, twitter, etc.
  id: '',
  profileImageURL: '',
  provider: ''
});

export default class User extends UserRecord {

  // TODO: Add email, twitter, etc. once I investigate how to merge accounts.
  // User id must be generated to not expose email, but technically email is id.
  // It will be used for auto merging social and email providers.
  // It must work OOTB without security issues, e.g. email must be checked.
  static fromFirebaseAuth(auth) {
    // https://groups.google.com/forum/#!topic/firebase-talk/s9mv4S46Qs0
    const {auth: {uid: id}, provider} = auth;
    const {
      cachedUserProfile, displayName, email, profileImageURL
    } = auth[provider];

    return new User({
      displayName,
      email,
      [provider]: cachedUserProfile,
      id,
      profileImageURL,
      provider
    });
  }

}
