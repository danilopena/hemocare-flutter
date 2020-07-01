class StockModel {
  StockModel({
    this.dosage,
    this.email,
    this.initialStock,
    this.name,
    this.pathology,
    this.percentageUsed,
    this.userId,
  });
  StockModel.fromDocument(Map<String, dynamic> documentSnapshot) {
    dosage = documentSnapshot['dosage'] as num;
    email = documentSnapshot['email'] as String;
    initialStock = documentSnapshot['initialStock'] as num;
    name = documentSnapshot['name'] as String;
    pathology = documentSnapshot['pathology'] as String;
    percentageUsed = documentSnapshot['percentageUsed'] as num;
    userId = documentSnapshot['userId'] as String;
  }

  num dosage;
  String email;
  //todo turn into int
  num initialStock;
  String name;
  String pathology;
  num percentageUsed;
  String userId;

  @override
  String toString() {
    return 'toString {initialStock: $initialStock, name: $name, pathology: $pathology, percentageUsed: $percentageUsed, userId: $userId}';
  }
}
