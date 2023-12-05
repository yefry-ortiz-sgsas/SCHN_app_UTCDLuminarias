import 'dart:convert';

ModelResumen modelResumenFromJson(String str) => ModelResumen.fromJson(json.decode(str));

String modelResumenToJson(ModelResumen data) => json.encode(data.toJson());

class ModelResumen {
    ModelResumen({
        this.asignadas,
        this.finalizadas,
        this.pendientes,
    });

    int asignadas;
    int finalizadas;
    int pendientes;

    factory ModelResumen.fromJson(Map<String, dynamic> json) => ModelResumen(
        asignadas: json["asignadas"],
        finalizadas: json["finalizadas"],
        pendientes: json["pendientes"],
    );

    Map<String, dynamic> toJson() => {
        "asignadas": asignadas,
        "finalizadas": finalizadas,
        "pendientes": pendientes,
    };
}
