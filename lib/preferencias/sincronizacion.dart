import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:inventario_luminarias/modelos/modelApoyo.dart';
import 'package:inventario_luminarias/modelos/modelApoyonuevo.dart';
import 'package:inventario_luminarias/modelos/modelImagen.dart';
import 'package:inventario_luminarias/modelos/modelLuminaria.dart';
import 'package:inventario_luminarias/preferencias/configuraciones.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SolSincronizacion {
  String _ip = Configuraciones().ipserver;
  String _port = Configuraciones().portserver;
  String host = Configuraciones().host;
  final prefs = new PreferenciasUsuario();
  final _bd = new DBAsignaciones();

  void getpendientes() async {
    //Envia apoyos temporales
    Future<List<ModelApoyonuevo>> apoyosreportados = _bd.getapoyoreportados();
    apoyosreportados.then((value) async {
      for (int i = 0; i < value.length; i++) {
        ModelApoyonuevo fila = value[i];
        int en = await enviaapoyorep(fila);
        if (en == 200) {
          int up = await _bd.updateEstadoApoyorep(fila.id, 1);
        }
      }
    });

    //Actualiza apoyos asignados
    Future<List<ModelApoyo>> enviapoyos = _bd.getupdasignacionesenviar();
    enviapoyos.then((value) async {
      for (int i = 0; i < value.length; i++) {
        ModelApoyo fila = value[i];
        int en = await updateapoyo(fila);
        if (en == 200) {
          int up = await _bd.updateEstadoApoyo(fila.idapoyo);
        }
      }
    });

    //envia alumbrado
    Future<List<ModelLuminaria>> envialuminaria = _bd.getluminariaspendientes();
    envialuminaria.then((value) async {
      for (int i = 0; i < value.length; i++) {
        ModelLuminaria fila = value[i];
        int en = await envialum(fila);
        if (en == 200) {
          int up = await _bd.updateluminaria(fila.idapoyo);
        }
      }
    });
  }

  void getpendientesimagenes() async {
    //Envia Imagenes
    Future<List<ModelApoyo>> enviapoyos = _bd.getupdasignacionesimagenes();
    enviapoyos.then((value) async {
      for (int i = 0; i < value.length; i++) {
        ModelApoyo fila = value[i];
        List<ModelImagen> imagenes =
            await _bd.listarimagenes(fila.idapoyo, fila.idot);
        int respuesta = 0;
        for (int k = 0; k < imagenes.length; k++) {
          ModelImagen imagen = imagenes[k];
          int enx = await enviaimg(imagen);
          if (enx == 200) {
          } else {
            respuesta++;
          }
        }
        print(
            "---->" + respuesta.toString() + " --->" + fila.idapoyo.toString());
        if (respuesta == 0) {
          int up = await _bd.updateEstadoApoyoImagen(fila.idapoyo);
        }
      }
    });
  }

  Future<int> enviaapoyorep(ModelApoyonuevo fila) async {
    int respuesta;
    if (await ConnectionVerify.connectionStatus()) {
      int ida = fila.id;
      int idot = fila.idot;
      String tipoapoyo = fila.tipoapoyo;
      double lat = fila.lat;
      double lon = fila.lon;
      String alturaapoyo = fila.alturaapoyo;
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$host/insertAsigApoyo',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body:
                    'ida=$ida&idot=$idot&tipoapoyo=$tipoapoyo&alturaapoyo=$alturaapoyo&lat=$lat&lon=$lon')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          Map<String, dynamic> decodeResp = json.decode(response.body);
          respuesta = decodeResp['response'];
          return respuesta;
        } else {
          print("Error server apoyo reportado");
          return 100;
        }
      } on TimeoutException {
        print("Error tiempo apoyo reportado");
        return 100;
      } on SocketException catch (_) {
        print("Error socket apoyo reportado");
        return 100;
      } on Error catch (e) {
        print(e);
        print("Error General apoyo reportado");
        return 100;
      }
    } else {
      return 100;
    }
  }

  Future<int> updateapoyo(ModelApoyo fila) async {
    int respuesta;
    if (await ConnectionVerify.connectionStatus()) {
      int ida = fila.idapoyo;
      int idot = fila.idot;
      print('http://$_ip:$_port/$host/updAsigApoyo');
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$host/updAsigApoyo',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body: 'ida=$ida&idot=$idot')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          Map<String, dynamic> decodeResp = json.decode(response.body);
          respuesta = decodeResp['response'];
          return respuesta;
        } else {
          print("Error server apoyo reportado");
          return 100;
        }
      } on TimeoutException {
        print("Error tiempo apoyo reportado");
        return 100;
      } on SocketException catch (_) {
        print("Error socket apoyo reportado");
        return 100;
      } on Error catch (e) {
        print(e);
        print("Error General apoyo reportado");
        return 100;
      }
    } else {
      return 100;
    }
  }

  Future<int> envialum(ModelLuminaria fila) async {
    int respuesta;
    if (await ConnectionVerify.connectionStatus()) {
      int ida = fila.idapoyo;
      int idot = fila.idot;
      String tipo = fila.tipo;
      String potencia = fila.potencia;
      String estadoluminaria = fila.estadoluminaria;
      String lat = fila.lat;
      String lon = fila.lon;
      String observacion = fila.observacion;
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$host/insertLuminaria',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body:
                    'ida=$ida&idot=$idot&tipo=$tipo&potencia=$potencia&estadoluminaria=$estadoluminaria&lat=$lat&lon=$lon&observacion=$observacion')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          Map<String, dynamic> decodeResp = json.decode(response.body);
          respuesta = decodeResp['response'];
          return respuesta;
        } else {
          print("Error server apoyo reportado");
          return 100;
        }
      } on TimeoutException {
        print("Error tiempo apoyo reportado");
        return 100;
      } on SocketException catch (_) {
        print("Error socket apoyo reportado");
        return 100;
      } on Error catch (e) {
        print(e);
        print("Error General apoyo reportado");
        return 100;
      }
    } else {
      return 100;
    }
  }

  Future<int> enviaimg(ModelImagen imagen) async {
    if (await ConnectionVerify.connectionStatus()) {
      File file = new File(imagen.foto);
      File fotocom = await compressFile(file);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://$_ip:$_port/$host/insertar_imagen"),
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'file',
          fotocom.readAsBytes().asStream(),
          fotocom.lengthSync(),
          filename: "imagen",
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);
      request.fields.addAll({"idapoyo": imagen.idapoyo.toString()});
      request.fields.addAll({"idot": imagen.idot.toString()});
      request.fields.addAll({"idtipo": imagen.tipo.toString()});
      var res = await request.send();
      return res.statusCode;
    } else {
      return 100;
    }
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 45,
    );
    print(file.lengthSync());
    print(result.lengthSync());
    return result;
  }
}
