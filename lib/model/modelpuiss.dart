class Puisance {
  int id;
  String puissance;

  Puisance({this.id, this.puissance});

  Puisance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    puissance = json['puissance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['puissance'] = this.puissance;
    return data;
  }
}