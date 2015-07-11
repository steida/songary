import EventEmitter from 'eventemitter3';
import React from 'react';
import {Dispatcher} from 'flux';
import {Map, List, fromJS} from 'immutable';

// Decorator HOC component.
export default function flux(actionsAndStores) {

  // TODO: Add invariant for actionsAndStores.
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
      // We can detect hot load, because module will get new actionsAndStores
      // instance, but instance is the same. Sweet.
      const wasHotLoaded = actionsAndStores !== this.flux.actionsAndStores;
      if (!wasHotLoaded) return;
      console.log('was hot loaded')
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

// Compose actions, stores, and app state.
export class Flux extends EventEmitter {

  constructor(initialState, actionsAndStores) {
    super();
    this.actionsAndStores = actionsAndStores;
    this._history = [];
    this.load(initialState);
  }

  setState(state) {
    // if (this._state === state) return;
    // this._state = state;
    // this.emit('change', this._state, previousState, path);
  }

  getState() {
    return this._state;
  }

  save() {
    return this.getState().toJS();
  }

  load(json) {
    // Deeply convert json to immutable map asap for two reasons:
    //  1) store getInitialState can't accidentally break anything
    //  2) immutables provide much richer api for manipulation
    const initialState = fromJS(json);
    const storesState = Map(this.actionsAndStores).map((value, key) => {
      const {store} = this._destruct(value);
      const storeInitialState = initialState.get(key);
      return store &&
        store(storeInitialState || Map(), 'init') || storeInitialState;
    });
    // TODO: Compose actions to have this.props.actions.auth.login etc.
    // TODO: Add pending actions somehow, should be actions immutable map?

    const actions = null;
    this._state = initialState.merge(storesState, {
      actions: actions,
      flux: this
    });
  }

  _destruct(value) {
    return {
      actions: List(value).find(item => typeof item === 'object'),
      store: List(value).find(item => typeof item === 'function')
    }
  }

  dispose() {
    this.removeAllListeners();
  }

}

