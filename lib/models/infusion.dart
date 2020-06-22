class Infusion {
  Infusion(
      {this.dateTime,
      this.description,
      this.dosage,
      this.infusionType,
      this.recurring,
      this.userId});
  Infusion.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'] as String;
    description = json['description'] as String;
    dosage = json['dosage'] as num;
    infusionType = json['infusionType'] as String;
    recurring = json['recurring'] as bool;
    userId = json['userId'] as String;
  }
  String dateTime;
  String description;
  num dosage;
  String infusionType;
  bool recurring;
  String userId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['description'] = description;
    data['dosage'] = dosage;
    data['infusionType'] = infusionType;
    data['recurring'] = recurring;
    data['userId'] = userId;
    return data;
  }
}
