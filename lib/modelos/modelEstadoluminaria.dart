import 'dart:convert';

ModelEstadoluminaria modelEstadoluminariaFromJson(String str) =>
    ModelEstadoluminaria.fromJson(json.decode(str));

String modelEstadoluminariaToJson(ModelEstadoluminaria data) =>
    json.encode(data.toJson());

class ModelEstadoluminaria {
  ModelEstadoluminaria({
    this.id,
    this.estado,
  });

  int id;
  String estado;

  factory ModelEstadoluminaria.fromJson(Map<String, dynamic> json) =>
      ModelEstadoluminaria(
        id: json["id"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estado": estado,
      };

  static List<ModelEstadoluminaria> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ModelEstadoluminaria.fromJson(item)).toList();
  }

  @override
  String toString() => estado;    
}
