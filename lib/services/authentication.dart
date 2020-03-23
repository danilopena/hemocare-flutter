import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();


}
class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<FirebaseUser> getCurrentUser() async {
    // TODO: implement getCurrentUser
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<bool> isEmailVerified() async {
    // TODO: implement isEmailVerified
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    // TODO: implement sendEmailVerification
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password) async {
    // TODO: implement signIn
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) async {
    // TODO: implement signUp
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

}