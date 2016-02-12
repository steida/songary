import AddSong from './songs/add.react';
import App from './app/app.react';
import EditSong from './songs/edit.react';
import Home from './home/index.react';
import Latest from './songs/latest.react';
import Login from './auth/index.react';
import Me from './me/index.react';
import MySongs from './songs/my.react';
import NotFound from './components/notfound.react';
import React from 'react';
import Song from './songs/song.react';
import {DefaultRoute, NotFoundRoute, Route} from 'react-router';

export default (
  <Route handler={App} path="/">
    <DefaultRoute handler={Home} name="home" />
    <NotFoundRoute handler={NotFound} name="not-found" />
    <Route handler={AddSong} name="add-song" />
    <Route handler={EditSong} name="songs-edit" path="songs/:id/edit" />
    <Route handler={Login} name="login" />
    <Route handler={Me} name="me" />
    <Route handler={MySongs} name="my-songs" />
    <Route handler={Latest} name="latest" path="latest/:createdAt?" />
    <Route handler={Song} name="song" path="songs/:id" />
  </Route>
);
