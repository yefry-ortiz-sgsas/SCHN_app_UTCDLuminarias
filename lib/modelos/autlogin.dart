import 'dart:convert';

ModelAut modelAutFromJson(String str) => ModelAut.fromJson(json.decode(str));

String modelAutToJson(ModelAut data) => json.encode(data.toJson());

class ModelAut {
    ModelAut({
        this.resultado,
        this.response,
        this.diplay,
        this.usuario,
        this.idu,
        this.sector,
    });

    String resultado;
    int response;
    String diplay;
    String usuario;
    String idu;
    String sector;

    factory ModelAut.fromJson(Map<String, dynamic> json) => ModelAut(
        resultado: json["resultado"],
        response: json["response"],
        diplay: json["diplay"],
        usuario: json["usuario"],
        idu: json["idu"],
        sector: json["sector"],
    );

    Map<String, dynamic> toJson() => {
        "resultado": resultado,
        "response": response,
        "diplay": diplay,
        "usuario": usuario,
        "idu": idu,
        "sector": sector,
    };
}
