import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  double dosage;
  String email;
  double initialStock;
  String name;
  String pathology;
  double percentageUsed;
  String userId;
  final DocumentReference reference;

  StockModel(
      {this.dosage,
      this.email,
      this.initialStock,
      this.name,
      this.pathology,
      this.percentageUsed,
      this.userId,
      this.reference});
  factory StockModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return StockModel(
      dosage: documentSnapshot["dosage"],
      email: documentSnapshot["email"],
      initialStock: documentSnapshot["initialStock"],
      name: documentSnapshot["name"],
      pathology: documentSnapshot["pathology"],
      percentageUsed: documentSnapshot["percentageUsed"],
      userId: documentSnapshot["userId"],
      reference: documentSnapshot.reference,
    );
  }
}
