import 'dart:convert';

ModelAlturaApoyo modelAlturaApoyoFromJson(String str) =>
    ModelAlturaApoyo.fromJson(json.decode(str));

String modelAlturaApoyoToJson(ModelAlturaApoyo data) =>
    json.encode(data.toJson());

class ModelAlturaApoyo {
  ModelAlturaApoyo({
    this.id,
    this.altura,
  });

  int id;
  int altura;

  factory ModelAlturaApoyo.fromJson(Map<String, dynamic> json) =>
      ModelAlturaApoyo(
        id: json["id"],
        altura: json["altura"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "altura": altura,
      };

  static List<ModelAlturaApoyo> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ModelAlturaApoyo.fromJson(item)).toList();
  }

  @override
  String toString() => altura.toString();
}
