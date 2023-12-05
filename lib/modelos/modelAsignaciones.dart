import 'dart:convert';

ModelOt modelOtFromJson(String str) => ModelOt.fromJson(json.decode(str));

String modelOtToJson(ModelOt data) => json.encode(data.toJson());

class ModelOt {
  ModelOt({
    this.idot,
    this.fechaasignacion,
    this.estado,
    this.sede,
    this.display,
    this.asignaciones,
    this.id,
    this.nombre,
  });

  int idot;
  DateTime fechaasignacion;
  String estado;
  String sede;
  String display;
  int asignaciones;
  int id;
  String nombre;

  factory ModelOt.fromJson(Map<String, dynamic> json) => ModelOt(
        idot: json["idot"],
        fechaasignacion: DateTime.parse(json["fechaasignacion"]),
        estado: json["estado"],
        sede: json["sede"],
        display: json["display"],
        asignaciones: json["asignaciones"],
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idot": idot,
        "fechaasignacion":
            "${fechaasignacion.year.toString().padLeft(4, '0')}-${fechaasignacion.month.toString().padLeft(2, '0')}-${fechaasignacion.day.toString().padLeft(2, '0')}",
        "estado": estado,
        "sede": sede,
        "display": display,
        "asignaciones": asignaciones,
        "id": id,
        "nombre": nombre,
      };
}
