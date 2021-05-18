import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/models/user_model.dart';

/* 
-- USE FIREBASE FOR STORING AND RETRIEVING DATA
  - this requirement is fufilled in this class

-- IMLEMENT AND USE YOUR OWN SERVICE
  - AuthService is a service to access the firebase database

This class is used for intraction with Firebase, to store and retrieve data
it is used for signing in, registering, signing out and retrieving user details 
*/

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // creating a custom user object based on firebase user to strip unnecessary information
  CustomUser _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  // stream used to detect if user is signed in or not
  Stream<CustomUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

  // function allowing user to sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // function allowing user to sign in with email and password
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // function allowing user to register with email and password
  Future registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // function allowing user to sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
