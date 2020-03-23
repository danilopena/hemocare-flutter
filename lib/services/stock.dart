import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:hemocare/services/local_storage.dart';

class StockHandler {
  final localStorage = new LocalStorageWrapper();

  Future getStock() async {
    String id = localStorage.retrieve("logged_id");
    final databaseReference = Firestore.instance;
    DocumentSnapshot documentSnapshot;
    await databaseReference
        .collection("users")
        .document(id)
        .get()
        .then((DocumentSnapshot ds) {
      documentSnapshot = ds;
    });
    return documentSnapshot;
  }

  Future createStock(String initialStock, String commonDosage) async {
    String id = localStorage.retrieve("logged_id");
    Response response = await Dio().post(
        "https://hemocare-backend.herokuapp.com/api/stock/create",
        queryParameters: {"userId": id},
        data: {"initialStock": initialStock, "dosage": commonDosage});
    return response;
  }

  Future addStock(double value) async {
    String id = localStorage.retrieve("logged_id");
    final databaseReference = Firestore.instance;
    DocumentSnapshot documentSnapshot;
    var previousStock;

    //get current stock
    await databaseReference
        .collection("users")
        .document(id)
        .get()
        .then((DocumentSnapshot ds) {
      documentSnapshot = ds;
      previousStock = ds.data["initialStock"];
    });
    if (previousStock != null) {
      print("PS" + previousStock.toString());
      print("Value" + value.toString());
      var sum = previousStock + value;
      await databaseReference
          .collection("users")
          .document(id)
          .updateData({"initialStock": sum, "percentageUsed": 0}).then(
              (value) => print("OK on then add"));
    }
    return documentSnapshot;
  }

  Future removeStock(double value) async {
    String id = localStorage.retrieve("logged_id");
    final databaseReference = Firestore.instance;
    DocumentSnapshot documentSnapshot;
    var currentStock;
    double percentageUsed = 0.0;
    double remainingStock = 0;
    await databaseReference
        .collection("users")
        .document(id)
        .get()
        .then((DocumentSnapshot ds) {
      currentStock = ds.data["initialStock"];
      documentSnapshot = ds;
    });
    if (currentStock != 0) {
      percentageUsed = (value / currentStock) * 100;
      remainingStock = currentStock - value;
      print(percentageUsed);
      print(remainingStock);
      await databaseReference.collection("users").document(id).updateData({
        'percentageUsed': percentageUsed,
        'initialStock': remainingStock,
      }).then((result) => print("OK on then"));
    }
    return documentSnapshot;
  }
}
