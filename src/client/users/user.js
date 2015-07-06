import {Record} from 'immutable';
import {silhouetteUrl} from '../cdn';

const UserRecord = Record({
  // Providers
  facebook: null,
  google: null,
  password: null,
  // Auth props
  provider: '',
  uid: '',
  // User props
  displayName: 'user.unknown',
  email: ''
});

class User extends UserRecord {

  get id() {
    return this.uid;
  }

  get providerData() {
    return this[this.provider];
  }

  get pictureUrl() {
    switch (this.provider) {
      case 'facebook':
        // The same height as Twitter bigger default, because it's in CSS.
        return `//graph.facebook.com/${this.providerData.id}/picture?type=normal&height=73`;
      case 'twitter':
        return this.providerData.cachedUserProfile.profile_image_url
          // Relative protocol: https://google-styleguide.googlecode.com/svn/trunk/htmlcssguide.xml#Protocol
          // TODO: Switch to https, because relative protocol is anti-pattern now.
          .replace('http:', '')
          // Bigger has 73px height.
          .replace('_normal', '_bigger');
      case 'google':
        // TODO: It's huge. Does exists smaller version?
        return this.providerData.cachedUserProfile.picture
          .replace('http:', '');
      default:
        return silhouetteUrl();
    }
  }
}

function extractDisplayName(user) {
  if (!user.providerData)
    return 'user.unknown';
  if (user.provider === 'password')
    return extractEmail(user);
  return user.providerData.displayName;
}

function extractEmail(user) {
  if (!user.providerData)
    return '';
  return user.providerData.email;
}

User.fromAuth = (auth) => {
  // Must be ignored: auth.expires, auth.token, auth[auth.provider].accessToken
  const providerData = auth[auth.provider];
  delete providerData.accessToken;
  const user = new User({
    [auth.provider]: providerData,
    provider: auth.provider,
    uid: auth.uid
  });
  return user.merge({
    displayName: extractDisplayName(user),
    email: extractEmail(user)
  });

};

export default User;
