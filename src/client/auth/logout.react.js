import * as actions from './actions';
import Component from '../components/component.react';
import React from 'react';
import {msg} from '../intl/store';

class Logout extends Component {

  render() {
    return (
      <button
        children={msg('buttons.logout')}
        className="btn btn-default"
        onClick={actions.logout}
      />
    );
  }

}

export default Logout;
