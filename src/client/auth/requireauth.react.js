import Component from '../components/component.react';
import React from 'react';
import {isLoggedIn} from '../users/store';

// Higher order component.
// https://medium.com/@dan_abramov/mixins-are-dead-long-live-higher-order-components-94a0d2f9e750
export default function requireAuth(BaseComponent) {

  class Authenticated extends Component {

    static displayName = `${BaseComponent.displayName || BaseComponent.name}Authenticated`;

    static willTransitionTo(transition) {
      if (isLoggedIn()) return;
      transition.redirect('login', {}, {
        nextPath: transition.path
      });
    }

    render() {
      return <BaseComponent {...this.props} />;
    }

  }

  return Authenticated;

}
