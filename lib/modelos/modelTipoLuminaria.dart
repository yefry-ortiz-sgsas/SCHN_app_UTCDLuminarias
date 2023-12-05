import 'dart:convert';

ModelTipoluminaria modelTipoluminariaFromJson(String str) =>
    ModelTipoluminaria.fromJson(json.decode(str));

String modelTipoluminariaToJson(ModelTipoluminaria data) =>
    json.encode(data.toJson());

class ModelTipoluminaria {
  ModelTipoluminaria({
    this.id,
    this.tipo,
  });

  int id;
  String tipo;

  factory ModelTipoluminaria.fromJson(Map<String, dynamic> json) =>
      ModelTipoluminaria(
        id: json["id"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
      };

  static List<ModelTipoluminaria> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ModelTipoluminaria.fromJson(item)).toList();
  }

  @override
  String toString() => tipo;
}
