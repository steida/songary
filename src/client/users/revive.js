import User from './user';
import {Map} from 'immutable';

export default function(value) {
  const viewer = value.get('viewer');
  return Map(value).set('viewer', viewer ? new User(viewer) : null);
}
