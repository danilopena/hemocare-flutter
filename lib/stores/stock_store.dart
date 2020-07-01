import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hemocare/models/stock_model.dart';
import 'package:mobx/mobx.dart';

part 'stock_store.g.dart';

class StockStore = _StockStore with _$StockStore;

abstract class _StockStore with Store {
  _StockStore() {
    loadCurrentUser().then((FirebaseUser user) {
      setIsOKToRender(user);
      setStockData();
    });
  }
  @observable
  StockModel stockModel;
  FirebaseUser currentUser;
  @observable
  bool isOkToRender = false;
  @observable
  double percentage = 0;

  @action
  void setPercentage(double value) {
    print(value);
    percentage = value;
  }

  @action
  void setIsOKToRender(FirebaseUser user) {
    isOkToRender = user != null;
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  @action
  Future<FirebaseUser> loadCurrentUser() async {
    currentUser = await firebaseAuth.currentUser();
    return currentUser;
  }

  @action
  Future<void> setStockData() async {
    if (isOkToRender) {
      final DocumentSnapshot snapshot =
          await firestore.collection('users').document(currentUser.uid).get();
      stockModel = StockModel.fromDocument(snapshot.data);
      setPercentage(stockModel.percentageUsed.toDouble());
      print(stockModel);
    }
  }
}
