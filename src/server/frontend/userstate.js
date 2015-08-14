import Promise from 'bluebird';
import Router from 'react-router';
import config from '../config';
import createFirebase from '../../client/firebase/create';
import routes from '../../client/routes';
import {Map} from 'immutable';

const firebase = createFirebase(config.firebaseUrl);

function getRouterStateFromReq(req) {
  return new Promise((resolve, reject) => {
    Router.create({
      routes,
      location: req.originalUrl,
      onError: reject,
      onAbort: reject
    }).run((Handler, state) => {
      resolve(state);
    });
  });
}

// A bit clunky, but works well.
function set404(condition, value) {
  if (condition) value.$404 = true;
  return value;
}

export default function userState() {

  return (req, res, next) => {
    // TODO: Refactor or use await async.
    getRouterStateFromReq(req)
      .then(({routes, params}) => {
        const routeName = routes
          .map(route => route.name)
          .filter(name => name)
          .join('/');

        loadUserData(req, routeName, params).then(loadedData => {
          req.userState = Map().merge(...loadedData);
          next();
        });
      })
      .catch(() => {
        req.userState = Map();
        next();
      });
  };

}

// Gracefully settle all promises, ignore failed.
function loadUserData(req, routeName, params) {
  const dataSources = [];
  if (routeName === 'song')
    dataSources.push(loadSong(params.id));

  return Promise.settle(dataSources).then(receivedData =>
    receivedData
      .filter(promise => promise.isFulfilled())
      .map(promise => promise.value())
  );
}

function loadSong(songId) {
  return firebase
    .once('value', ['songs', songId])
    .then(snapshot => {
      const song = snapshot.val();
      return set404(!song, {
        songs: {
          map: {[songId]: song}
        }
      });
    });
}
