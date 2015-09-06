import Component from '../components/component.react';
import React from 'react';
import exposeRouter from '../components/exposerouter';
import {createValidate} from '../validate';

import * as authActions from '../auth/actions';
import * as firebaseActions from '../firebase/actions';
import * as songsActions from '../songs/actions';

const actions = [authActions, firebaseActions, songsActions];

export default function createActions(BaseComponent) {

  @exposeRouter
  class CreateActions extends Component {

    static propTypes = {
      firebase: React.PropTypes.object,
      flux: React.PropTypes.object.isRequired,
      msg: React.PropTypes.object.isRequired,
      router: React.PropTypes.func.isRequired
    }

    componentWillMount() {
      this.actions = this.createActions();
    }

    createActions() {
      const {firebase, flux, msg, router} = this.props;
      const state = () => flux.state.toObject();
      const validate = createValidate(() => msg);

      return actions.reduce((actions, {create, feature, inject}) => {
        const dispatch = (action, payload) =>
          flux.dispatch(action, payload, {feature});

        const deps = [dispatch, validate, firebase, router, state];
        const args = inject ? inject(...deps) : deps;
        return {...actions, [feature]: create(...args)};
      }, {});
    }

    render() {
      return <BaseComponent {...this.props} actions={this.actions} />;
    }

  };

  return CreateActions;

}
