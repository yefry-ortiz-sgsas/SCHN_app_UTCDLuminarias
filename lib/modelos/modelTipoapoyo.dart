import 'dart:convert';

ModelTipoApoyo modelTipoApoyoFromJson(String str) =>
    ModelTipoApoyo.fromJson(json.decode(str));

String modelTipoApoyoToJson(ModelTipoApoyo data) => json.encode(data.toJson());

class ModelTipoApoyo {
  ModelTipoApoyo({
    this.id,
    this.tipo,
  });

  int id;
  String tipo;

  factory ModelTipoApoyo.fromJson(Map<String, dynamic> json) => ModelTipoApoyo(
        id: json["id"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
      };

  static List<ModelTipoApoyo> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ModelTipoApoyo.fromJson(item)).toList();
  }

  @override
  String toString() => tipo;
}
