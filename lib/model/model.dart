
import 'dart:ffi';


class Transformateur {
  int id;
  String image;
  String identification;
  String numeroSerie;
  String poidsHuile;
  String poidsTotal;
  String status;
  String marque;
  String puissance;

  Transformateur(
      {this.id,
        this.image,
        this.identification,
        this.numeroSerie,
        this.poidsHuile,
        this.poidsTotal,
        this.status,
        this.marque,
        this.puissance});

  Transformateur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    identification = json['identification'];
    numeroSerie = json['numero_serie'];
    poidsHuile = json['poids_huile'];
    poidsTotal = json['poids_total'];
    status = json['status'];
    marque = json['marque'] ;
    puissance = json['puissance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['identification'] = this.identification;
    data['numero_serie'] = this.numeroSerie;
    data['poids_huile'] = this.poidsHuile;
    data['poids_total'] = this.poidsTotal;
    data['status'] = this.status;
    data['marque'] = this.marque;
    data['puissance'] = this.puissance;

    return data;
  }
}
