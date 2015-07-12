import EventEmitter from 'eventemitter3';
import React from 'react';
import {Dispatcher} from 'flux';
import {List, Map, Record, fromJS} from 'immutable';

// Higher order component to fluxify app. Can be used as ES2016 decorator.
export default function flux(actionsAndStores) {
  // TODO: Use Flux invariant for actionsAndStores.

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
      // TODO: How dev tools will be able to measure rerender?
      // Shalow clone to get immutable object props.
      this.setState(this.flux.getState().toObject());
    }

    componentWillReceiveProps() {
      // Hot load reloads modules, but React instance is the same. Sweet.
      const wasHotLoaded = actionsAndStores !== this.flux.actionsAndStores;
      if (!wasHotLoaded) return;
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

// Atomic immutable functional Flux with hot reloading.
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
    //  3) we can leverage immutable record to provide json-like dot access.
    const initialState = fromJS(json);
    const storesState = this._createStoresState(initialState);
    const actions = this._createActions();
    this._state = initialState.merge(storesState, {
      actions: actions,
      flux: this
    });
    this._createDispatcher();
  }

  _createStoresState(initialState) {
    return Map(this.actionsAndStores).map((value, key) => {
      const {store} = this._getActionsAndStores(value);
      const state = initialState.get(key);
      return store && store(state || Map(), 'init') || state;
    });
  }

  _createActions() {
    return Map(this.actionsAndStores).reduce((record, value, feature) => {
      const {actions} = this._getActionsAndStores(value);
      if (!actions) return record;
      const featureActions = this._createFeatureActions(feature, actions);
      return record.set(feature, featureActions)
    }, this._createEmptyRecord(this.actionsAndStores));
  }

  _createFeatureActions(feature, actions) {
    return Map(actions).reduce((record, action, name) => {
      return record.set(name, (...args) => {
        const payload = action(...args);
        return this._dispatch(feature, name, payload, action);
      });
    }, this._createEmptyRecord(actions));
  }

  _createEmptyRecord(object) {
    const emptyObject = Map(object).map(item => null).toJS();
    return new (Record(emptyObject));
  }

  // So people can use [actions, store], [actions], [store], [].
  _getActionsAndStores(value) {
    const find = type => List(value).find(item => typeof item === type);
    return {
      actions: find('object'),
      store: find('function')
    }
  }

  _createDispatcher() {
    // TODO: Use smarter waitFor, pass it into store.
    this._dispatcher = new Dispatcher;
    // sync a async, a nastavovani pending pro akce
  }

  _dispatch(feature, name, payload, action) {
    console.log(feature, name, payload, action);
    this._dispatcher
    // waitFor, predavat ve storu, ok
    // pokud store neco vrati, zmenim state, a preda, set state
    // this.emit('dispatch', feature, name, payload, action);
  }

  dispose() {
    this.removeAllListeners();
  }

}

