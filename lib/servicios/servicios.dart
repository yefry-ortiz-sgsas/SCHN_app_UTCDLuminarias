import 'package:connection_verify/connection_verify.dart';
import 'package:http/http.dart' as http;
import 'package:inventario_luminarias/modelos/modelApoyo.dart';
import 'package:inventario_luminarias/modelos/modelAsignaciones.dart';
import 'package:inventario_luminarias/modelos/modelEliminaOs.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:inventario_luminarias/preferencias/configuraciones.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';

class Solicitudes {
  String _ip = Configuraciones().ipserver;
  String _port = Configuraciones().portserver;
  String _host = Configuraciones().host;
  final prefs = new PreferenciasUsuario();
  final _bd = new DBAsignaciones();

  Future<int> logUsuario(String user, String con, String tk) async {
    try {
      http.Response response = await http
          .post('http://$_ip:$_port/$_host/loginbk',
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
              },
              body: 'user=$user&con=$con&t=1&tk=$tk')
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        Map<String, dynamic> decodeResp = json.decode(response.body);
        print("Respuesta de envio informacion---> " + decodeResp.toString());
        if (decodeResp['response'] == 200) {
          if (decodeResp['resultado'] == "S") {
            prefs.idusuario = int.parse(decodeResp['idu']);
            prefs.usuario = user;
            prefs.sesion = "S";
            prefs.inicio = "homeuser";
            prefs.sector = decodeResp['sectordetalle'];
            prefs.codsector = decodeResp['sector'];
            return 1;
          } else {
            return 0;
          }
        } else {
          return -1;
        }
      } else {
        print("Error server");
        return -1;
      }
    } on TimeoutException catch (_) {
      return -1;
    } on SocketException catch (_) {
      print("Error de conexion con el servidor.");
      return -1;
    }
  }

  Future<bool> cargaAsiganciones() async {
    if (await ConnectionVerify.connectionStatus()) {
      int idu = prefs.idusuario;
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$_host/listarotusuarios',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body: 'id=$idu')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          List<dynamic> tagsJson = jsonDecode(response.body)['listarot'];
          for (int k = 0; k < tagsJson.length; k++) {
            final os = new ModelOt.fromJson(tagsJson[k]);
            final existe = await _bd.existeasignacion(os.idot);
            if (existe == 0) {
              print("Se inserto--->" + os.id.toString());
              await _bd.nuevaasignacion(os);
            } else {
              print("Se encontro--->" + os.id.toString());
            }
          }
          return true;
        } else {
          print("Error server");
          return false;
        }
      } on TimeoutException {
        print("Error tiempo");
        return false;
      } on SocketException catch (_) {
        print("Error socket");
        return false;
      } on Error catch (e) {
        print(e);
        print("Error General");
        return false;
      }
    }
  }

  Future<bool> cargaAsigancionesApoyos() async {
    if (await ConnectionVerify.connectionStatus()) {
      int idu = prefs.idusuario;
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$_host/listarotapoyo',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body: 'id=$idu')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          List<dynamic> tagsJson = jsonDecode(response.body)['listarapoyos'];
          for (int k = 0; k < tagsJson.length; k++) {
            final os = new ModelApoyo.fromJson(tagsJson[k]);
            final existe = await _bd.existeasignacionapoyo(os.idot, os.idapoyo);
            if (existe == 0) {
              print("Se inserto--->" + os.idapoyo.toString());
              await _bd.nuevaasignacionApoyo(os);
            } else {
              print("Se encontro--->" + os.idapoyo.toString());
            }
          }
          return true;
        } else {
          print("Error server");
          return false;
        }
      } on TimeoutException {
        print("Error tiempo");
        return false;
      } on SocketException catch (_) {
        print("Error socket");
        return false;
      } on Error catch (e) {
        print(e);
        print("Error General");
        return false;
      }
    }
  }

  Future<bool> eliminaAsiganciones() async {
    if (await ConnectionVerify.connectionStatus()) {
      int idu = prefs.idusuario;
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$_host/listaroteliminadasusuarios',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body: 'id=$idu')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          List<dynamic> tagsJson = jsonDecode(response.body)['listarot'];
          for (int k = 0; k < tagsJson.length; k++) {
            final os = new ModelEliminaOs.fromJson(tagsJson[k]);
            bool re = await actualizaeliminaAsiganciones(os.idot);
            print("idot elimina:--->" + os.idot.toString());
            if (re) {
              await _bd.deleteasiganciones(os.idot);
              await _bd.deletegeneral(os.idot);
              print("idot general elimina:--->" + os.idot.toString());
            }
          }
          return true;
        } else {
          print("Error server");
          return false;
        }
      } on TimeoutException {
        print("Error tiempo");
        return false;
      } on SocketException catch (_) {
        print("Error socket");
        return false;
      } on Error catch (e) {
        print(e);
        print("Error General");
        return false;
      }
    }
  }

  Future<bool> actualizaeliminaAsiganciones(int id) async {
    print("http://$_ip:$_port/$_host/updestadoeliminaAsig?id=$id:--->" +
        id.toString());
    if (await ConnectionVerify.connectionStatus()) {
      try {
        http.Response response = await http
            .post('http://$_ip:$_port/$_host/updestadoeliminaAsig',
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
                body: 'id=$id')
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          Map<String, dynamic> decodeResp = json.decode(response.body);
          int respuesta = decodeResp['response'];
          if (respuesta == 200) {
            return true;
          } else {
            return false;
          }
        } else {
          print("Error server");
          return false;
        }
      } on TimeoutException {
        print("Error tiempo");
        return false;
      } on SocketException catch (_) {
        print("Error socket");
        return false;
      } on Error catch (e) {
        print(e);
        print("Error General");
        return false;
      }
    }
  }
}
