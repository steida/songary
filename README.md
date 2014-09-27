# Songary [![Build Status](https://secure.travis-ci.org/steida/songary.png?branch=master)](http://travis-ci.org/steida/songary) [![Dependency Status](https://david-dm.org/steida/songary.png)](https://david-dm.org/steida/songary) [![devDependency Status](https://david-dm.org/steida/songary/dev-status.png)](https://david-dm.org/steida/songary#info=devDependencies)

Your personal song book. [Demo](http://songary.jit.su/).

Made with [Este.js](https://github.com/steida/este).

## Install and run

Read [Este.js](https://github.com/steida/este).

## Learn

Just read source code, there are plethora of comments. 

#### CoffeeScript, Really?

I like CoffeeScript and significant whitespace. I'm enjoying CoffeeScript for years and it just works. But I understand that some people doubt about CS future, or simply doesn't like it. I will add gulp task to switch to plain old JavaScript soon. It will just delete `*.coffee` files and update `.gitignore`. Done. Now you have JavaScript version :-) But I would like to do more than that. Yes, ES6 is coming in town. I will add ES6 version once Closure Compiler finish its [work](https://github.com/google/closure-compiler/wiki/ECMAScript6).

## Demonstrated Techniques
  - frontend/mobile/offline first
  - isomorphic web app
  - Closure Tools
  - Facebook React and Flux
  - one way data flow
  - Polymer PointerEvents
  - clean code
  - Promises
  - app state persisted in localStorage
  - pending navigation and other [SPA UX patterns](https://medium.com/joys-of-javascript/beyond-pushstate-building-single-page-applications-4353246f4480)
  - dependency injection with awesome DI container
  - statically typed code written in CoffeeScript
  - killer React.js HTML syntax
  - Firebase and realtime collaboration
  - finest [dev stack](https://github.com/steida/gulp-este)

### Why Facebook [Flux](http://facebook.github.io/flux/) is better than XYZ?

Because [Ember computed properties](http://emberjs.com/guides/object-model/computed-properties/) and [Backbone model events](http://backbonejs.org/#Events) and [Angular scope hierarchies and scope events](https://docs.angularjs.org/guide/scope) mix app model with app data flow, irreversibly.

Imagine you have two models, A and B. And you would like to change B whenever A is changed. Events and computed properties works well, unless you need to change A without B be also changed. Got it? Flux uses `waitFor` method to explicitly describe what should be changed in which order.




