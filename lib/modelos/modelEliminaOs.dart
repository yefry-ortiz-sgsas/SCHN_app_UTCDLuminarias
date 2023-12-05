import 'dart:convert';

ModelEliminaOs modelEliminaOsFromJson(String str) =>
    ModelEliminaOs.fromJson(json.decode(str));

String modelEliminaOsToJson(ModelEliminaOs data) => json.encode(data.toJson());

class ModelEliminaOs {
  ModelEliminaOs({
    this.id,
    this.idot,
    this.estado,
    this.idusuario,
  });

  int id;
  int idot;
  int estado;
  int idusuario;

  factory ModelEliminaOs.fromJson(Map<String, dynamic> json) => ModelEliminaOs(
        id: json["id"],
        idot: json["idot"],
        estado: json["estado"],
        idusuario: json["idusuario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idot": idot,
        "estado": estado,
        "idusuario": idusuario,
      };
}
