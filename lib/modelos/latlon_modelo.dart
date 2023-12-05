import 'dart:convert';

LatLon latLonFromJson(String str) => LatLon.fromJson(json.decode(str));

String latLonToJson(LatLon data) => json.encode(data.toJson());

class LatLon {
    LatLon({
        this.lat,
        this.lon,
        this.direccion,
    });

    String lat;
    String lon;
    String direccion;

    factory LatLon.fromJson(Map<String, dynamic> json) => LatLon(
        lat: json["lat"],
        lon: json["lon"],
        direccion: json["direccion"],
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "direccion": direccion,
    };

     //@override
     //String toString() => "["+lat+","+lon+"]";
}
