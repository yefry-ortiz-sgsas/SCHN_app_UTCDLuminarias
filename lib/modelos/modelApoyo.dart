import 'dart:convert';

ModelApoyo modelApoyoFromJson(String str) =>
    ModelApoyo.fromJson(json.decode(str));

String modelApoyoToJson(ModelApoyo data) => json.encode(data.toJson());

class ModelApoyo {
  ModelApoyo({
    this.idot,
    this.circuito,
    this.estado,
    this.pintadoapoyo,
    this.idapoyo,
    this.lon,
    this.fecharegistro,
    this.lat,
    this.apoyotemporal,
    this.idusuario,
    this.estadoimagen
  }){
    if(this.apoyotemporal==null){
      this.apoyotemporal = 0;
    }
  }

  int idot;
  String circuito;
  String estado;
  String pintadoapoyo;
  int idapoyo;
  double lon;
  String fecharegistro;
  double lat;
  int apoyotemporal;
  int idusuario;
  int estadoimagen;

  factory ModelApoyo.fromJson(Map<String, dynamic> json) => ModelApoyo(
        idot: json["idot"],
        circuito: json["circuito"],
        estado: json["estado"],
        pintadoapoyo: json["pintadoapoyo"],
        idapoyo: json["idapoyo"],
        lon: json["lon"].toDouble(),
        fecharegistro: json["fecharegistro"],
        lat: json["lat"].toDouble(),
        apoyotemporal: json["apoyotemporal"],
        idusuario: json["idusuario"],
        estadoimagen: json["estadoimagen"]
      );

  Map<String, dynamic> toJson() => {
        "idot": idot,
        "circuito": circuito,
        "estado": estado,
        "pintadoapoyo": pintadoapoyo,
        "idapoyo": idapoyo,
        "lon": lon,
        "fecharegistro": fecharegistro,
        "lat": lat,
        "apoyotemporal": apoyotemporal,
        "idusuario": idusuario,
        "estadoimagen": estadoimagen
      };
}
