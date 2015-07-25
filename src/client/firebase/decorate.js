import Component from '../components/component.react';
import React from 'react';
import create from './create';

export default function decorate(BaseComponent) {

  return class Decorator extends Component {

    static propTypes = {
      users: React.PropTypes.object
    }

    componentWillMount() {
      // We are using Firebase on client side exclusively for now.
      if (!process.env.IS_BROWSER) return;
      const firebaseUrl = this.props.config.get('firebaseUrl');
      this.firebase = create(firebaseUrl);
    }

    render() {
      return <BaseComponent {...this.props} firebase={this.firebase} />;
    }

  };

}
