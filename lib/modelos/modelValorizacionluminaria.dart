import 'dart:convert';

ModelValorizacionluminaria modelValorizacionluminariaFromJson(String str) =>
    ModelValorizacionluminaria.fromJson(json.decode(str));

String modelValorizacionluminariaToJson(ModelValorizacionluminaria data) =>
    json.encode(data.toJson());

class ModelValorizacionluminaria {
  ModelValorizacionluminaria({
    this.id,
    this.valor,
  });

  int id;
  String valor;

  factory ModelValorizacionluminaria.fromJson(Map<String, dynamic> json) =>
      ModelValorizacionluminaria(
        id: json["id"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "valor": valor,
      };

  static List<ModelValorizacionluminaria> fromJsonList(List list) {
    if (list == null) return null;
    return list
        .map((item) => ModelValorizacionluminaria.fromJson(item))
        .toList();
  }

  @override
  String toString() => valor;
}
