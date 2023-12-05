import 'dart:convert';

ModelApoyonuevo modelApoyonuevoFromJson(String str) =>
    ModelApoyonuevo.fromJson(json.decode(str));

String modelApoyonuevoToJson(ModelApoyonuevo data) =>
    json.encode(data.toJson());

class ModelApoyonuevo {
  ModelApoyonuevo(
      {this.id,
      this.lat,
      this.lon,
      this.alturaapoyo,
      this.tipoapoyo,
      this.estado, this.idot});

  int id;
  double lat;
  double lon;
  String alturaapoyo;
  String tipoapoyo;
  int estado;
  int idot;

  factory ModelApoyonuevo.fromJson(Map<String, dynamic> json) =>
      ModelApoyonuevo(
        id: json["id"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        alturaapoyo: json["alturaapoyo"],
        tipoapoyo: json["tipoapoyo"],
        estado: json["estado"],
        idot: json["idot"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "lon": lon,
        "alturaapoyo": alturaapoyo,
        "tipoapoyo": tipoapoyo,
        "estado": estado,
        "idot": idot
      };
}
