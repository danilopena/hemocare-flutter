import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemocare/services/local_storage.dart';
import 'package:mobx/mobx.dart';

part 'user_controller.g.dart';

class UserController = UserBase with _$UserController;

abstract class UserBase with Store {
  @observable
  double percent;
  @observable
  double initialStock;

  @action
  getDocument() {
    String uid = new LocalStorageWrapper().retrieve("logged_id");
    Firestore.instance.collection("users").document(uid).get().then((DocumentSnapshot document) {
      print("Document called");
      print("Data: ${document.data}");
      if (document.data != null) {
        percent = double.parse(document?.data["percentageUsed"].toString());
        initialStock = double.parse(document?.data["initialStock"].toString());
      } else {
        percent = 0;
        initialStock = 0;
      }
    });
  }
}
