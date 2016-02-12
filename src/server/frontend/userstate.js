import Promise from 'bluebird';
import Router from 'react-router';
import config from '../config';
import createFirebase from '../../client/firebase/create';
import routes from '../../client/routes';
import songsStore from '../../client/songs/store';
import {Map} from 'immutable';
import {actions as songsActions} from '../../client/songs/actions';
import {latestPageSize} from '../../client/songs/latest.react';

const firebase = createFirebase(config.firebaseUrl);

function set404(condition, value) {
  if (condition) value.$404 = true;
  return value;
}

export default function userState() {

  return (req, res, next) => {
    getRouterState(req.originalUrl)
      .then(routerState => loadUserData(routerState, req))
      .then(loadedData => {
        req.userState = Map().merge(...loadedData);
        next();
      })
      .catch(() => {
        req.userState = Map();
        next();
      });
  };

}

function getRouterState(originalUrl) {
  return new Promise((resolve, reject) => {
    Router.run(routes, originalUrl, (Root, state) => resolve(state));
  });
}

function loadUserData(routerState, req) {
  const {params, routes} = routerState;
  const currentRoutePath = routes
    .map(route => route.name)
    .filter(name => name)
    .join('/');
  const dataSources = [];

  const routesLoaders = {
    latest: () => loadLatestSongs(Number(params.createdAt)),
    song: () => loadSong(params.id)
  };
  const routeLoader = routesLoaders[currentRoutePath];

  if (routeLoader)
    dataSources.push(routeLoader());

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
      // TODO: Use songs store.
      return set404(!song, {
        songs: {
          map: {[songId]: song}
        }
      });
    });
}

function loadLatestSongs(createdAt) {
  return new Promise((resolve, reject) => {
    firebase.root
      .child('songs')
      .orderByChild('createdAt')
      .endAt(createdAt ? createdAt : Date.now())
      .limitToLast(latestPageSize)
      .once('value', resolve, reject);
  })
  .then(snapshot => {
    const songs = snapshot.val();
    const state = songsStore(Map(), songsActions.onLatest, {createdAt, songs});
    return {
      songs: state.toJS()
    };
  });
}
