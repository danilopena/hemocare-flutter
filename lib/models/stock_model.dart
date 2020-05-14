class StockModel {
  int dosage;
  String email;
  //todo turn into int
  int initialStock;
  String name;
  String pathology;
  double percentageUsed;
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
    // Unhandled Exception: type 'int' is not a subtype of type 'double'\
    //  Unhandled Exception: type 'double' is not a subtype of type 'int'
    initialStock = documentSnapshot["initialStock"];
    name = documentSnapshot["name"];
    pathology = documentSnapshot["pathology"];
    percentageUsed = documentSnapshot["percentageUsed"];
    userId = documentSnapshot["userId"];
  }
}
