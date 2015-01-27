# Songary [![Build Status](https://secure.travis-ci.org/steida/songary.png?branch=master)](http://travis-ci.org/steida/songary) [![Dependency Status](https://david-dm.org/steida/songary.png)](https://david-dm.org/steida/songary) [![devDependency Status](https://david-dm.org/steida/songary/dev-status.png)](https://david-dm.org/steida/songary#info=devDependencies)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/steida/songary?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Your personal song book. [Demo](http://songary.jit.su/).

Made with [Este.js](https://github.com/steida/este).

__Still under development. Just experimental project for now. __

## Install and run

Read [Este.js](https://github.com/steida/este).

## Techniques
  - frontend/mobile/offline first
  - isomorphic web app
  - Closure Library and Closure Compiler
  - Facebook [React](http://facebook.github.io/react/) and [Flux](http://facebook.github.io/flux/)
  - one way data flow
  - polymes-gestures
  - global error handling both for sync and async code
  - Promises based apis
  - app state persisted in localStorage and synced across browsing contexts
  - pending navigation and other [SPA UX patterns](https://medium.com/joys-of-javascript/beyond-pushstate-building-single-page-applications-4353246f4480)
  - clean code via dependency injection with awesome DI container
  - statically typed code written in CoffeeScript
  - killer React JSX-less syntax
  - finest [dev stack](https://github.com/steida/gulp-este)

#### Why CoffeeScript?

I like CoffeeScript and significant whitespace. I'm enjoying CoffeeScript for years and it just works. But I understand that some people doubt about CS future, or simply doesn't like it. I will add gulp task to switch to plain old JavaScript soon. It will just delete `*.coffee` files and update `.gitignore`. Done. Now you have JavaScript version :-) But I would like to do more than that. Yes, ES6 is coming in town. I will add ES6 version once Closure Compiler finish its [work](https://github.com/google/closure-compiler/wiki/ECMAScript6).
