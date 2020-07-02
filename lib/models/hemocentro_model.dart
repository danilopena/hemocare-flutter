class Hemocentro {
  String address;
  String googleUrl;
  String email;
  String image;
  String name;
  List<dynamic> phones;
  String state;

  Hemocentro(
      {this.address,
      this.googleUrl,
      this.email,
      this.image,
      this.name,
      this.phones,
      this.state});

  Hemocentro.fromJson(Map<String, dynamic> json) {
    address = json['address'] as String;
    googleUrl = json['googleUrl'] as String;
    email = json['email'] as String;
    image = json['image'] as String;
    name = json['name'] as String;
    phones = json['phones'] as List<dynamic>;
    state = json['state'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['googleUrl'] = googleUrl;
    data['email'] = email;
    data['image'] = image;
    data['name'] = name;
    data['phones'] = phones;
    data['state'] = state;
    return data;
  }
}
