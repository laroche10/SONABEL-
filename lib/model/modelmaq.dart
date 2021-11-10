class Marq {
  int id;
  String marque;

  Marq({this.id, this.marque});

  Marq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marque = json['marque'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['marque'] = this.marque;
    return data;
  }
}