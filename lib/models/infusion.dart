class Infusion {
  String dateTime;
  String description;
  int dosage;
  String infusionType;
  bool recurring;
  String userId;

  Infusion(
      {this.dateTime,
      this.description,
      this.dosage,
      this.infusionType,
      this.recurring,
      this.userId});

  Infusion.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    dosage = json['dosage'];
    infusionType = json['infusionType'];
    recurring = json['recurring'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['description'] = this.description;
    data['dosage'] = this.dosage;
    data['infusionType'] = this.infusionType;
    data['recurring'] = this.recurring;
    data['userId'] = this.userId;
    return data;
  }
}
