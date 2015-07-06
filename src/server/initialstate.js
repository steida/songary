import config from './config';
import messages from '../client/messages';

const initialLocale = 'en';

export default {
  auth: {
    data: null,
    form: null
  },
  firebase: {
    listenedRefs: [],
    url: config.firebaseUrl
  },
  i18n: {
    formats: {},
    locales: initialLocale,
    messages: messages[initialLocale]
  },
  pendingActions: {},
  users: {
    map: {},
    viewer: null
  }
};
