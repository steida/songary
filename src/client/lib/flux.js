// Reduced functional immutable Flux.
// We don't need Flux dispatcher. It's impossible to call action within another
// action, and we don't need waitFor with atomic app state.

import EventEmitter from 'eventemitter3';
import React from 'react';
import {List, Map, Record, fromJS} from 'immutable';

export default function flux(actionsAndStores) {
  // TODO: Add invariant for actionsAndStores

  return BaseComponent => class FluxDecorator extends React.Component {

    static propTypes = {
      initialState: React.PropTypes.object
    }

    componentWillMount() {
      this.fluxify();
    }

    fluxify() {
      if (this.flux) this.flux.dispose();
      this.flux = new Flux(this.props.initialState, actionsAndStores);
      this.flux.on('statechange', ::this.setFluxState);
      this.setFluxState();
    }

    setFluxState() {
      // For component state we need shallow clone.
      // TODO: How dev tools will be able to measure rerender?
      this.setState(this.flux.getState().toObject());
    }

    componentWillReceiveProps() {
      // Hot load reloads modules, but React instance is the same. Sweet.
      const wasHotLoaded = actionsAndStores !== this.flux.actionsAndStores;
      if (!wasHotLoaded) return;
      //  console.log('was hot loaded')
      this.fluxify();
    }

    componentWillUnmount() {
      this.flux.dispose();
    }

    render() {
      return <BaseComponent {...this.state} />;
    }

  }
}

export class Flux extends EventEmitter {

  constructor(initialState, actionsAndStores) {
    super();
    this.actionsAndStores = actionsAndStores;
    this.load(initialState);
  }

  setState(state) {
    if (this._state === state) return;
    this._state = state;
    this.emit('statechange', this._state);
  }

  getState() {
    return this._state;
  }

  save() {
    return this.getState().toJS();
  }

  load(json) {
    // Deeply convert json to immutable map asap because:
    //  1) store getInitialState can't accidentally break anything
    //  2) immutables provide much richer api for manipulation
    //  3) we can leverage immutable record so json is not needed anyway
    const initialState = fromJS(json);
    const storesState = this._createStoresState(initialState);
    const actions = this._createActions();
    this._state = initialState.merge(storesState, {
      actions: actions,
      flux: this
    });
  }

  _createStoresState(initialState) {
    return Map(this.actionsAndStores).map((value, key) => {
      const {store} = this._destruct(value);
      const state = initialState.get(key);
      return store && store(state || Map(), 'init') || state;
    });
  }

  _createActions() {
    const defaultValuesOf = obj => Map(obj).map(item => null).toJS();
    // Features like auth, users, todos, etc.
    let actionsRecord = new (Record(defaultValuesOf(this.actionsAndStores)));
    Map(this.actionsAndStores).forEach((value, feature) => {
      const {actions, store} = this._destruct(value);
      if (!actions) return;
      let featureActionRecord = new (Record(defaultValuesOf(actions)));
      Map(actions).forEach((action, name) => {
        featureActionRecord = featureActionRecord.set(name, (...args) => {
          const payload = action(...args);
          return this._dispatch(feature, name, action, payload);
        });
      });
      actionsRecord = actionsRecord.set(feature, featureActionRecord);
    });
    return actionsRecord;
  }

  // So people can use [actions, store], [actions], [store], [].
  _destruct(value) {
    const find = type => List(value).find(item => typeof item === type);
    return {
      actions: find('object'),
      store: find('function')
    }
  }

  _dispatch(feature, name, action, payload) {
    console.log(feature, name, action, payload);

    // do vsech storu predam state, action, payload
    // a pokud store neco vrati, musim to promitnout
    // coz musi vyvolat rerender, ok
  }

  dispose() {
    this.removeAllListeners();
  }

}

