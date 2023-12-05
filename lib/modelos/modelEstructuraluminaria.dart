import 'dart:convert';

ModelEstructuraluminaria modelEstructuraluminariaFromJson(String str) =>
    ModelEstructuraluminaria.fromJson(json.decode(str));

String modelEstructuraluminariaToJson(ModelEstructuraluminaria data) =>
    json.encode(data.toJson());

class ModelEstructuraluminaria {
  ModelEstructuraluminaria({
    this.id,
    this.estructura,
  });

  int id;
  String estructura;

  factory ModelEstructuraluminaria.fromJson(Map<String, dynamic> json) =>
      ModelEstructuraluminaria(
        id: json["id"],
        estructura: json["estructura"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estructura": estructura,
      };

  static List<ModelEstructuraluminaria> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ModelEstructuraluminaria.fromJson(item)).toList();
  }

  @override
  String toString() => estructura;
}
