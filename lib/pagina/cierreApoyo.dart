import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:inventario_luminarias/modelos/ModelPotencialuminaria.dart';
import 'package:inventario_luminarias/modelos/modelEstadoluminaria.dart';
import 'package:inventario_luminarias/modelos/modelLuminaria.dart';
import 'package:inventario_luminarias/modelos/modelTipoLuminaria.dart';
import 'package:inventario_luminarias/modelos/modelValorizacionluminaria.dart';
import 'package:inventario_luminarias/pagina/camara.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' as Io;

class LuminariacierreNueva extends StatefulWidget {
  @override
  _LuminariacierreNuevaState createState() => _LuminariacierreNuevaState();
}

class _LuminariacierreNuevaState extends State<LuminariacierreNueva> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _bd = new DBAsignaciones();
  final prefs = new PreferenciasUsuario();
  List<ModelTipoluminaria> tipolumin = new List<ModelTipoluminaria>();
  List<ModelPotencialuminaria> potencialumin =
      new List<ModelPotencialuminaria>();
  List<ModelEstadoluminaria> estadolumi = new List<ModelEstadoluminaria>();
  List<ModelValorizacionluminaria> valorizacionlumi =
      new List<ModelValorizacionluminaria>();
  String _tipolumi = "";
  String _estadolumi = "";
  String _potencialumi = "";
  String _valorizacionlumi = "";
  int _selectedIndex = 0;
  String observaciones = "";
  TextEditingController _controllerobs;
  bool guardar = true;
  bool activafoto = true;
  bool foto_panoramica = false;
  bool foto_estructura = false;
  bool foto_luminaria = false;
  Io.File foto;

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    _data();
    super.initState();
  }

  void _data() async {
    List<ModelTipoluminaria> lista1 = await _bd.gettipoluminarias();
    List<ModelPotencialuminaria> lista2 = await _bd.getpotenciasluminarias();
    List<ModelEstadoluminaria> lista3 = await _bd.getestadosluminarias();
    List<ModelValorizacionluminaria> lista4 =
        await _bd.getvalorizacionluminarias();
    setState(() {
      tipolumin = lista1;
      potencialumin = lista2;
      estadolumi = lista3;
      valorizacionlumi = lista4;
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!");
    atras();
    return true;
  }

  void atras() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation);
            //initialize SizerUtil
            return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text('Cierre'),
                  leading: Visibility(
                    visible: guardar,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => atras(),
                    ),
                  ),
                ),
                body: nuevaLuminaria(context),
                bottomNavigationBar: Visibility(
                  visible: guardar,
                  child: BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      backgroundColor: HexColor("#5FD0DF"), //015796
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.done_outline, color: Colors.white),
                            title: Text('Finalizar',
                                style: TextStyle(color: Colors.white))),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.close, color: Colors.white),
                            title: Text('Cancelar',
                                style: TextStyle(color: Colors.white)))
                      ],
                      onTap: (int index) async {
                        setState(() {
                          _selectedIndex = index;
                        });
                        if (index == 1) {
                          Navigator.pop(context);
                        } else {
                          bool r = await _guardarInformacion(context);
                          if (r) {
                            prefs.idapoyotempo = -2;
                            show(context, "Resultado",
                                "Información guardada, con éxito.", 1);
                            Navigator.pop(context);
                            guardar = false;
                            activafoto = true;
                          }
                        }
                      }),
                ));
          },
        );
      },
    );
  }

  Widget nuevaLuminaria(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 2.0.h),
            ListTile(
              onTap: () {
                _subirfotografia(1);
              },
              leading: CircleAvatar(
                backgroundColor:
                    foto_panoramica ? Colors.blueAccent : Colors.orangeAccent,
                child: Icon(Icons.camera_alt),
                foregroundColor: Colors.white,
              ),
              title: Text('Fotografía panoramica'),
            ),
            ListTile(
              onTap: () {
                _subirfotografia(2);
              },
              leading: CircleAvatar(
                backgroundColor:
                    foto_estructura ? Colors.blueAccent : Colors.orangeAccent,
                child: Icon(Icons.camera_alt),
                foregroundColor: Colors.white,
              ),
              title: Text('Fotografía de la estructura'),
            ),
            ListTile(
              onTap: () {
                _subirfotografia(3);
              },
              leading: CircleAvatar(
                backgroundColor:
                    foto_luminaria ? Colors.blueAccent : Colors.orangeAccent,
                child: Icon(Icons.camera_alt),
                foregroundColor: Colors.white,
              ),
              title: Text('Fotografía de la luminaria'),
            ),
          ],
        ),
      )
    ]);
  }

  void _subirfotografia(int act) async {
    bool eliminar = await eliminarImagen(prefs.idapoyotrabajar, act);
    prefs.actividadgen = act;
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CamaraVentana()))
        .then((value) async {
      setState(() {
        if (prefs.actividadgen == 0) {
          if (act == 1) {
            foto_panoramica = true;
          }
          if (act == 2) {
            foto_estructura = true;
          }
          if (act == 3) {
            foto_luminaria = true;
          }
          show(context, "Alerta", "Fotografia ingresada, con exito.", 1);
        } else {
          show(context, "Alerta", "Debe tomar una fotografía.", 2);
        }
      });
    });
  }

  /*void _subirfotografia(int act) async {
    //int idact = await _bdListas.getnameactividad("MedidorInstalado");MedidorInstalado
    FocusScope.of(context).unfocus();
    bool eliminar = await eliminarImagen(prefs.idapoyotrabajar, act);
    if (eliminar) {
      bool r = await _procesarImagen(ImageSource.camera);
      if (r) {
        String path = foto.path.toString();
        bool img = await guardarImagen(
            prefs.idapoyotrabajar, prefs.idotpref, path, act);
        if (img) {
          setState(() {
            if (act == 1) {
              foto_panoramica = true;
            }
            if (act == 2) {
              foto_estructura = true;
            }
            if (act == 3) {
              foto_luminaria = true;
            }
          });
          show(context, "Alerta", "Fotografia ingresada, con exito.", 1);
        } else {
          show(
              context, "Alerta", "Ocurrio un error al tomar la fotografía.", 2);
        }
      } else {
        show(context, "Alerta", "Debe tomar una fotografía.", 2);
      }
    }
  }*/

  Future<bool> _procesarImagen(ImageSource origen) async {
    bool resp = false;
    foto = await ImagePicker.pickImage(source: origen);
    if (foto != null) {
      resp = true;
    } else {
      resp = false;
    }
    setState(() {});
    return resp;
  }

  Future<bool> _guardarInformacion(BuildContext context) async {
    //Estados luminarias
    // - 1 edicion luminaria
    // - 2 nueva luminaria
    // - 3 enviada luminaria
    int r = await _bd.updateEstadoEspecial(
        prefs.idapoyotrabajar, "Finalizada", prefs.idapoyotempo);
    return true;
  }
}
