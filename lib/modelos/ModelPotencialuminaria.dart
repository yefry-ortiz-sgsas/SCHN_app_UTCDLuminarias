import 'dart:convert';

ModelPotencialuminaria modelPotencialuminariaFromJson(String str) =>
    ModelPotencialuminaria.fromJson(json.decode(str));

String modelPotencialuminariaToJson(ModelPotencialuminaria data) =>
    json.encode(data.toJson());

class ModelPotencialuminaria {
  ModelPotencialuminaria({
    this.id,
    this.potencia,
  });

  int id;
  String potencia;

  factory ModelPotencialuminaria.fromJson(Map<String, dynamic> json) =>
      ModelPotencialuminaria(
        id: json["id"],
        potencia: json["potencia"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "potencia": potencia,
      };

  static List<ModelPotencialuminaria> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ModelPotencialuminaria.fromJson(item)).toList();
  }

  @override
  String toString() => potencia;     
}
