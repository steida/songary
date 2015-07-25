import Song from './song';
import {List, Record, Seq} from 'immutable';
import {actions} from './actions';

function revive(state) {
  return new (Record({
    add: new Song,
    list: List()
  }));
}

export default function(state, action, payload) {
  if (!action) state = revive(state);

  switch (action) {

    case actions.add:
      return state.set('add', new Song);

    case actions.onFirebaseSongs:
      return state.set('list', Seq(payload)
        .sortBy(item => item.updatedAt || item.createdAt)
        .reverse()
        .toList()
      );

    case actions.setAddField:
      return state.setIn(['add', payload.name], payload.value);

  }

  return state;
}
