import compression from 'compression';
import config from '../config';
import esteHeaders from '../lib/estemiddleware';
import express from 'express';
import favicon from 'serve-favicon';
import i18nLoader from '../lib/i18nmiddleware';
import render from './render';
import userState from './userstate';

const app = express();

// Add Este.js headers for React related routes only.
if (!config.isProduction)
  app.use(esteHeaders());

app.use(compression());
app.use(favicon('assets/img/favicon.ico'));
app.use('/build', express.static('build'));
app.use('/assets', express.static('assets'));

// Load translations, fallback to defaultLocale if no
// translations available.
app.use(i18nLoader({
  defaultLocale: config.defaultLocale
}));

// Load state extras for current user.
app.use(userState());

app.get('*', (req, res, next) => {
  render(req, res, req.userState, {i18n: req.i18n}).catch(next);
});

app.on('mount', () => {
  console.log('App is available at %s', app.mountpath);
});

export default app;
