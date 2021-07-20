import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_neuron/model/my_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // method: create MyUser object based on FirebaseUser object
  MyUser _userFromFirebaseUser(User? user) {
    return MyUser(user!.uid);
  }

  // method: map from Firebase User to MyUser object
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // method: sign in anonymously via Firebase (not in used atm)
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user); // convert to MyUser object
    } catch (e) {
      print('sign in anon error: ${e.toString()}');
      return null;
    }
  }

  // method: sign in with email and password via Firebase
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user); // convert to MyUser object
    } catch (e) {
      print('sign-in with email error: ${e.toString()}');
      return null;
    }
  }

  // method: register with email and password via Firebase
  Future registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //await DatabaseService(uid: user!.uid).updateUserData({});
      return _userFromFirebaseUser(user); // convert to MyUser object
    } catch (e) {
      print('register with email error: ${e.toString()}');
      return null;
    }
  }

  // method: sign out of Firebase
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('sign out error: ${e.toString()}');
      return null;
    }
  }
}
