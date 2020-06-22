import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemocare/models/stock_model.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:mobx/mobx.dart';

part 'stock_store.g.dart';

class StockStore = _StockStore with _$StockStore;

abstract class _StockStore with Store {
  @observable
  String uid = "";
  @observable
  DocumentSnapshot stockData;
  @observable
  StockModel modelFromSnapshot = StockModel();

  @action
  void setModel(StockModel model) => modelFromSnapshot = model;

  @action
  void setSnapshot(DocumentSnapshot snapshot) => stockData = snapshot;

  @action
  Future<void> setUid() async {
    String preUid;
    LocalStorageWrapper ls = new LocalStorageWrapper();
    preUid = ls.retrieve("logged_id");
    uid = preUid;
  }

  @action
  Future<void> setStockData() async {
    StockModel model;
    await Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((snapshot) {
      print("snap store");
      print(snapshot.data);
      if (snapshot.data != null) {
        setSnapshot(snapshot);
      }
    }).whenComplete(() {
      model = StockModel.fromDocument(stockData?.data);
      setModel(model);
    });
  }

  @computed
  bool get isOkToRender =>
      modelFromSnapshot?.initialStock != null && uid != null;
}
