import EventEmitter from 'eventemitter3';
import Promise from 'bluebird';
import React from 'react';
import {Dispatcher} from 'flux';
import {List, Map, Record, fromJS} from 'immutable';

const isDev = 'production' !== process.env.NODE_ENV;

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

// Atomic Flux with hot reloading.
export class Flux extends EventEmitter {

  static emptyRecord(object) {
    const emptyObject = Map(object).map(item => null).toJS();
    return new (Record(emptyObject));
  }

  // So people can use [actions, store], [actions], [store], [].
  static findActionsAndStores(array) {
    const find = type => List(array).find(item => typeof item === type);
    return {actions: find('object'), store: find('function') };
  }

  static enrichAction(action, name, feature, isPending) {
    action.isPending = isPending;
    action.toString = () => feature + '/' + name;
    return action;
  }

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
    return Map(this.actionsAndStores).map((array, feature) => {
      const {store} = Flux.findActionsAndStores(array);
      const state = initialState.get(feature);
      return store && store(state || Map(), 'init') || state;
    });
  }

  _createActions() {
    return Map(this.actionsAndStores).reduce((record, array, feature) => {
      const {actions} = Flux.findActionsAndStores(array);
      if (!actions) return record;
      const featureActions = this._createFeatureActions(feature, actions);
      return record.set(feature, featureActions)
    }, Flux.emptyRecord(this.actionsAndStores));
  }

  _createFeatureActions(feature, actions) {
    return Map(actions).reduce((record, action, name) => {
      return record.set(name, Flux.enrichAction((...args) => {
        const payload = action(...args);
        return this._dispatch(action, payload, name, feature);
      }, name, feature, () => false));
    }, Flux.emptyRecord(actions));
  }

  _createDispatcher() {
    // No need to dispose dispatcher, GC will eat it.
    this._dispatcher = new Dispatcher;
    Map(this.actionsAndStores).forEach((array, feature) => {
      const {store} = Flux.findActionsAndStores(array);
      if (!store) return;
      this._dispatcher.register(this._onDispatch.bind(this, feature, store));
    });
  }

  _onDispatch(feature, store, {action, payload}) {
    const storeState = this._state.get(feature);
    const newStoreState = store(storeState, action, payload);
    if (!newStoreState) return;
    const newState = this._state.set(feature, newStoreState);
    this.setState(newState);
  }

  _dispatch(action, payload, name, feature) {
    const payloadIsPromise = payload && typeof payload.then === 'function';
    return payloadIsPromise
      ? this._asyncDispatch(action, payload, name, feature)
      : this._syncDispatch(action, payload, name, feature);
  }

  _syncDispatch(action, payload, name, feature) {
    // TODO: Move into dev tools.
    if (isDev) console.log(feature + '/' + name);
    this._dispatcher.dispatch({action, payload, name, feature});
    return Promise.resolve();
  }

  _asyncDispatch(action, payloadAsPromise, name, feature) {
    if (isDev) console.log(`pending ${feature + '/' + name}`); // eslint-disable-line no-console
    this._setPending(action, payloadAsPromise, name, feature, true);
    return payloadAsPromise.then(
      (payload) => {
        this._setPending(action, payloadAsPromise, name, feature, false);
        this._syncDispatch(action, payload, name, feature);
        return payload;
      },
      (reason) => {
        if (isDev) console.log(`reject ${feature + '/' + name}`); // eslint-disable-line no-console
        this._setPending(action, payloadAsPromise, name, feature, false);
        throw reason;
      }
    );
  }

  _setPending(action, payloadAsPromise, name, feature, isPending) {
    const newAction = Flux.enrichAction((...args) => action(...args),
      name, feature,
      // TODO: Consider payloadAsPromise for per action granularity.
      () => isPending
    );
    this._setAction(feature, name, newAction);
  }

  _setAction(feature, name, action) {
    this.setState(this._state.setIn(['actions', feature, name], action));
  }

  dispose() {
    this.removeAllListeners();
  }

}

