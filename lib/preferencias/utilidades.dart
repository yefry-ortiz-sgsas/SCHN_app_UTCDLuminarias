import 'dart:convert';

import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inventario_luminarias/modelos/latlon_modelo.dart';
import 'package:inventario_luminarias/modelos/modelImagen.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'dart:io' as Io;

void show(BuildContext context, String titulo, String text, int color) {
  var _color;
  var _icon;

  _icon = Icon(
    Icons.done_all,
    color: Colors.white,
  );

  if (titulo == "Alerta") {
    _icon = Icon(Icons.perm_device_information, color: Colors.white);
  }

  if (color == 1) {
    _color = HexColor("#fba115");
  }
  if (color == 2) {
    _color = HexColor("#ff0000");
  }

  AchievementView(
    context,
    title: titulo,
    subTitle: text,
    isCircle: true,
    color: _color,
    icon: _icon,
    listener: (status) {
      print(status);
    },
  )..show();
}

Future<LatLon> getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  debugPrint('location: ${position.latitude}');
  final coordinates = new Coordinates(position.latitude, position.longitude);
  LatLon coord = LatLon.fromJson({
    "lat": coordinates.latitude.toString(),
    "lon": coordinates.longitude.toString(),
    "direccion": ""
  });
  print("Coordenadas enviadas===>" + coord.lat);
  return coord;
}

Future<bool> eliminarImagen(int os, int idact) async {
   try {
    final _bdListas = new DBAsignaciones();
    int d = await _bdListas.eliminarImagen(os, idact);
    return  true;
  } catch (e) {
    print("Ocurrio un error al eliminar la imagen");
    return false;
  }
}

Future<bool> guardarImagen(int ida, int idot, String path, int tipo) async {
  bool resp = false;
  try {
    final _bdListas = new DBAsignaciones();
    ModelImagen guardar = ModelImagen.fromJson({
      "id": 0,
      "idapoyo": ida,
      "idot": idot,
      "foto": path,
      "tipo": tipo,
    });
    await _bdListas.nuevaFoto(guardar);
    return resp = true;
  } catch (e) {
    print("Ocurrio un error al guardar la imagen");
    return resp = false;
  }
}
