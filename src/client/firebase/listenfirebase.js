import Component from '../components/component.react';
import React from 'react';

export default function listenFirebase(getArgs) {

  return BaseComponent => class ListenFirebase extends Component {

    static displayName = `${BaseComponent.displayName}ListenFirebase`;

    static propTypes = {
      actions: React.PropTypes.object.isRequired
    };

    componentDidMount() {
      this.props.actions.firebase.onDecoratorDidMount(this, getArgs);
    }

    componentDidUpdate() {
      this.props.actions.firebase.onDecoratorDidUpdate(this, getArgs);
    }

    componentWillUnmount() {
      this.props.actions.firebase.onDecoratorWillUnmount(this);
    }

    render() {
      return <BaseComponent {...this.props} />;
    }

  };

}
