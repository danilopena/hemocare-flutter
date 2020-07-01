import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @observable
  String uid;
  bool get isLoggedIn => uid != null;

  @action
  Future<void> loadCurrentUser({FirebaseUser user}) async {
    final FirebaseUser currentUser = user ?? await firebaseAuth.currentUser();
    uid = currentUser.uid;
  }
}
