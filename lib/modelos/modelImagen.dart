// To parse this JSON data, do
//
//     final modelImagen = modelImagenFromJson(jsonString);

import 'dart:convert';

ModelImagen modelImagenFromJson(String str) =>
    ModelImagen.fromJson(json.decode(str));

String modelImagenToJson(ModelImagen data) => json.encode(data.toJson());

class ModelImagen {
  ModelImagen({this.idapoyo, this.idot, this.foto, this.tipo, this.id});

  int idapoyo;
  int id;
  int idot;
  String foto;
  int tipo;

  factory ModelImagen.fromJson(Map<String, dynamic> json) => ModelImagen(
        id: json["id"],
        idapoyo: json["idapoyo"],
        idot: json["idot"],
        foto: json["foto"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idapoyo": idapoyo,
        "idot": idot,
        "foto": foto,
        "tipo": tipo,
      };
}
