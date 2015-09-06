import Component from '../components/component.react';
import React from 'react';
import create from './create';

export default function decorate(BaseComponent) {

  return class Decorator extends Component {

    static propTypes = {
      config: React.PropTypes.object
    }

    componentWillMount() {
      // We are using Firebase on client side exclusively for now.
      if (!process.env.IS_BROWSER) return;
      const {config} = this.props;
      this.firebase = create(config.get('firebaseUrl'));
    }

    render() {
      return <BaseComponent {...this.props} firebase={this.firebase} />;
    }

  };

}
