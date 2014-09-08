# Songary [![Build Status](https://secure.travis-ci.org/steida/songary.png?branch=master)](http://travis-ci.org/steida/songary) [![Dependency Status](https://david-dm.org/steida/songary.png)](https://david-dm.org/steida/songary) [![devDependency Status](https://david-dm.org/steida/songary/dev-status.png)](https://david-dm.org/steida/songary#info=devDependencies)

Your personal song book. [Demo](http://songary.jit.su/).

Made with [Este.js](https://github.com/steida/este). _Still under heavy development._

## Install and run

Read [Este.js](https://github.com/steida/este).

## Learn

How? Just read code, there are plethora of comments. 

### Illustrated Techniques
  - frontend/mobile/offline first
  - isomorphic web apps
  - Closure Tools
  - Facebook React
  - Polymer PointerEvents
  - one way data flow
  - clean architecture
  - promises everywhere
  - app state stored in stores instead of React props and state
  - app state immediately persisted in LocalStorage
  - pending navigation
  - DI container
  - statically typed code written in CoffeeScript
  - killer React.js syntax
  - Firebase and realtime collaboration
  - super tunned [dev stack](https://github.com/steida/gulp-este)

### Songary versus [Facebook Flux](http://facebook.github.io/flux/)

Flux is nice pattern. You can read long articles about it, or read distilled happy day summary how it basically works right now: When you click on something in React component, some handler will dispatch some action on Dispatcher. Action is just string with some arguments. Any store can listen Dispatcher, then update itself somehow, then fire change event for React component to signalize component should be updated. That's almost all. 

Instead of traditional [Ember computed properties](http://emberjs.com/guides/object-model/computed-properties/) or [Backbone model events](http://backbonejs.org/#Events), or [Angular scope hierarchies and scope events](https://docs.angularjs.org/guide/scope), there is just one Dispatcher.

Why? Because with Angular/Ember/Backbone declarative approach, you are mixing two concerns: Model definition and data flow. Such approach is very hard to maintain for larger applications. Yes, it works great for for simple demos, but it does not scale. Flux embraces actions as independent app first class citizens. 

Imagine you have two models, A and B. And you would like to change B whenever A is updated. Events and computed properties works well, unless you need to update A without B be also changed. Got it? Flux uses waitFor method to explicitly describe what should be changed in which order.

And Songary? Songary is an isomorphic offline first app. Stores holds the app state, but persistence must be handled out of them, because the same store must works both on client(browser) and server(Node.js). 

In Flux there is a strict rule, every user action must be encapsuled into action. Then responsible store has to register itself to handle change somehow. Songary almost always prefers to call method on store. Method can change store state immediately, and it's ok, but it can also dispatch change event for Storage, and Storage can orchestrate cascading changes between various stores.



