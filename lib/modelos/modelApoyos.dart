import 'dart:convert';

ModelApoyos modelApoyosFromJson(String str) =>
    ModelApoyos.fromJson(json.decode(str));

String modelApoyosToJson(ModelApoyos data) => json.encode(data.toJson());

class ModelApoyos {
  ModelApoyos({
    this.idApoyo,
    this.circuito,
    this.materialapoyo,
    this.pintadoapoyo,
    this.lon,
    this.subestacion,
    this.id,
    this.alturaapoyo,
    this.idtrafoasignacion,
    this.lat,
    this.idasignacion,
    this.tipoapoyo,
  });

  int idApoyo;
  String circuito;
  String materialapoyo;
  String pintadoapoyo;
  double lon;
  String subestacion;
  int id;
  String alturaapoyo;
  int idtrafoasignacion;
  double lat;
  int idasignacion;
  String tipoapoyo;

  factory ModelApoyos.fromJson(Map<String, dynamic> json) => ModelApoyos(
        idApoyo: json["id_apoyo"],
        circuito: json["circuito"],
        materialapoyo: json["materialapoyo"],
        pintadoapoyo: json["pintadoapoyo"],
        lon: json['lon'] == null ? 0 : json["lon"].toDouble(),
        subestacion: json["subestacion"],
        id: json["id"],
        alturaapoyo: json["alturaapoyo"],
        idtrafoasignacion: json["idtrafoasignacion"],
        lat: json['lat'] == null ? 0 : json["lat"].toDouble(),
        idasignacion: json["idasignacion"],
        tipoapoyo: json["tipoapoyo"],
      );

  Map<String, dynamic> toJson() => {
        "id_apoyo": idApoyo,
        "circuito": circuito,
        "materialapoyo": materialapoyo,
        "pintadoapoyo": pintadoapoyo,
        "lon": lon,
        "subestacion": subestacion,
        "id": id,
        "alturaapoyo": alturaapoyo,
        "idtrafoasignacion": idtrafoasignacion,
        "lat": lat,
        "idasignacion": idasignacion,
        "tipoapoyo": tipoapoyo,
      };
}
