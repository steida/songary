import Promise from 'bluebird';
import Immutable from 'immutable';

// Example how initialState, which is the same for all users, is enriched with
// user state. With state-less Flux, we don't need instances.
export default function userState() {

  return (req, res, next) => {
    loadUserData(req).then(loadedData => {
      req.userState = Immutable.Map().merge(...loadedData);
      next();
    });
  };

}

// Gracefully settle all promises, ignore failed.
function loadUserData(req) {
  const dataSources = [
  ];

  return Promise.settle(dataSources).then(receivedData =>
    receivedData
      .filter(promise => promise.isFulfilled())
      .map(promise => promise.value())
  );
}

// // Simulate async action.
// function loadTodos() {
//   return new Promise((resolve, reject) => {
//     setTimeout(() => {
//       const todos = {
//         todos: {
//           list: [
//             {id: 2, title: 'relax'}
//           ]
//         }
//       };

//       resolve(todos);
//     }, 20);
//   });
// }