import 'dart:convert';

ModelLuminaria modelLuminariaFromJson(String str) => ModelLuminaria.fromJson(json.decode(str));

String modelLuminariaToJson(ModelLuminaria data) => json.encode(data.toJson());

class ModelLuminaria {
    ModelLuminaria({
        this.id,
        this.idapoyo,
        this.tipo,
        this.tipootros,
        this.potencia,
        this.potenciaotros,
        this.estadoluminaria,
        this.lat,
        this.lon,
        this.observacion,
        this.fechaRegistro,
        this.idot,
    });

    int id;
    int idapoyo;
    String tipo;
    String tipootros;
    String potencia;
    String potenciaotros;
    String estadoluminaria;
    String lat;
    String lon;
    String observacion;
    String fechaRegistro;
    int idot;

    factory ModelLuminaria.fromJson(Map<String, dynamic> json) => ModelLuminaria(
        id: json["id"],
        idapoyo: json["idapoyo"],
        tipo: json["tipo"],
        tipootros: json["tipootros"],
        potencia: json["potencia"],
        potenciaotros: json["potenciaotros"],
        estadoluminaria: json["estadoluminaria"],
        lat: json["lat"],
        lon: json["lon"],
        observacion: json["observacion"],
        fechaRegistro: json["fechaRegistro"],
        idot: json["idot"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idapoyo": idapoyo,
        "tipo": tipo,
        "tipootros": tipootros,
        "potencia": potencia,
        "potenciaotros": potenciaotros,
        "estadoluminaria": estadoluminaria,
        "lat": lat,
        "lon": lon,
        "observacion": observacion,
        "fechaRegistro": fechaRegistro,
        "idot": idot,
    };
}
