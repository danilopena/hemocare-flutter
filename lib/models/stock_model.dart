class StockModel {
  int dosage;
  String email;
  int initialStock;
  String name;
  String pathology;
  int percentageUsed;
  String userId;

  StockModel({
    this.dosage,
    this.email,
    this.initialStock,
    this.name,
    this.pathology,
    this.percentageUsed,
    this.userId,
  });

  @override
  String toString() {
    return 'toString {initialStock: $initialStock, name: $name, pathology: $pathology, percentageUsed: $percentageUsed, userId: $userId}';
  }

  StockModel.fromDocument(Map<String, dynamic> documentSnapshot) {
    dosage = documentSnapshot["dosage"];
    email = documentSnapshot["email"];
    initialStock = documentSnapshot["initialStock"];
    name = documentSnapshot["name"];
    pathology = documentSnapshot["pathology"];
    percentageUsed = documentSnapshot["percentageUsed"];
    userId = documentSnapshot["userId"];
  }
}
