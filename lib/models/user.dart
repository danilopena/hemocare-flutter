class User {
  num dosage;
  String email;
  num initialStock;
  String name;
  String pathology;
  num percentageUsed;
  String userId;

  User(
      {this.dosage,
      this.email,
      this.initialStock,
      this.name,
      this.pathology,
      this.percentageUsed,
      this.userId});

  User.fromJson(Map<String, dynamic> json) {
    dosage = json['dosage'] as num;
    email = json['email'] as String;
    initialStock = json['initialStock'] as num;
    name = json['name'] as String;
    pathology = json['pathology'] as String;
    percentageUsed = json['percentageUsed'] as num;
    userId = json['userId'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dosage'] = dosage;
    data['email'] = email;
    data['initialStock'] = initialStock;
    data['name'] = name;
    data['pathology'] = pathology;
    data['percentageUsed'] = percentageUsed;
    data['userId'] = userId;
    return data;
  }
}
