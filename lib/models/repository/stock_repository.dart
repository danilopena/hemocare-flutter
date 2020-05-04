import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemocare/models/repository/stock_repository_interface.dart';
import 'package:hemocare/models/stock_model.dart';

class StockRepository implements IStockRepository {
  final Firestore firestore;
  String userId;
  StockRepository(this.firestore, this.userId);
  @override
  Stream<StockModel> getStock() {
    return firestore
        .collection("users")
        .document(userId)
        .snapshots()
        .map((query) {
      StockModel model = StockModel.fromDocument(query);

      return model;
    });
  }
}
