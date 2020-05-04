import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'stock_store.g.dart';

class StockStore = _StockStore with _$StockStore;

abstract class _StockStore with Store {
  @observable
  String uid = "";
  @observable
  ObservableFuture<FirebaseUser> user;

  void setUid(String value) => uid = value;

  @observable
  ObservableFuture<DocumentSnapshot> stockData;

  @action
  Future<void> retrieveUid() async {
    user = FirebaseAuth.instance.currentUser().asStream().first.asObservable();
    setUid(user.value.uid);
  }

  @action
  Future<void> retrieveStockData() async {
    stockData = Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .asObservable();
  }

  @computed
  bool get isAlright => stockData.value.data != null && user.value.uid != null;
}
