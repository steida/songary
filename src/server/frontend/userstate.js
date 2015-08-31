import Promise from 'bluebird';
import Router from 'react-router';
import config from '../config';
import createFirebase from '../../client/firebase/create';
import routes from '../../client/routes';
import {Map} from 'immutable';

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
    song: () => loadSong(params.id),
    songs: () => loadSongs()
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
      return set404(!song, {
        songs: {
          map: {[songId]: song}
        }
      });
    });
}

function loadSongs() {
  return firebase
    .once('value', ['songs'])
    .then(snapshot => {
      return {
        songs: {
          map: snapshot.val()
        }
      };
    });
}
