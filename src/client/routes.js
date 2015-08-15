import AddSong from './songs/add.react';
import App from './app/app.react';
import Home from './home/index.react';
import Login from './auth/index.react';
import Me from './me/index.react';
import NotFound from './components/notfound.react';
import React from 'react';
import Song from './songs/song.react';
import Songs from './songs/index.react';
import {DefaultRoute, NotFoundRoute, Route} from 'react-router';

export default (
  <Route handler={App} path="/">
    <DefaultRoute handler={Home} name="home" />
    <NotFoundRoute handler={NotFound} name="not-found" />
    <Route handler={AddSong} name="songs-add" path="add-song" />
    <Route handler={Login} name="login" />
    <Route handler={Me} name="me" />
    <Route handler={Songs} name="songs" path="songs" />
    <Route handler={Song} name="song" path="songs/:id" />
  </Route>
);
