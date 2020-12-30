const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const functions = require('firebase-functions');

exports.myFunction = functions.firestore
  .document('my-collection/{docId}')
  .onWrite((change, context) => { /* ... */ });
