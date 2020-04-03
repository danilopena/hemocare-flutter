class User {
  double dosage;
  String email;
  double initialStock;
  String name;
  String pathology;
  double percentageUsed;
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
    dosage = json['dosage'];
    email = json['email'];
    initialStock = double.parse(json['initialStock']);
    name = json['name'];
    pathology = json['pathology'];
    percentageUsed = double.parse(json['percentageUsed']);
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dosage'] = this.dosage;
    data['email'] = this.email;
    data['initialStock'] = this.initialStock;
    data['name'] = this.name;
    data['pathology'] = this.pathology;
    data['percentageUsed'] = this.percentageUsed;
    data['userId'] = this.userId;
    return data;
  }
}
