import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:camera/camera.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' show join;
import 'dart:io' as Io;

class LuminariaNueva extends StatefulWidget {
  @override
  _LuminariaNuevaState createState() => _LuminariaNuevaState();
}

class _LuminariaNuevaState extends State<LuminariaNueva> {
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

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON! ENVIA ATRAKKKS NAVE");
    return false;
    //atras();
  }

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
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  void atras() async {
    Navigator.pop(context);
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
                  title: Text('Nueva Luminaria'),
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
                      backgroundColor: HexColor("#015796"),
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.done_outline, color: Colors.white),
                            title: Text('Agregar Luminaria',
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
                            show(context, "Resultado",
                                "La luminaria fue guardada, con éxito.", 1);
                            guardar = false;
                            activafoto = true;
                            Navigator.pop(context);
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
            _tipoluminaria(),
            SizedBox(height: 2.0.h),
            _potencialuminaria(),
            SizedBox(height: 2.0.h),
            _estadoluminaria(),
            SizedBox(height: 2.0.h),
            _valorluminaria(),
            SizedBox(height: 3.0.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Observaciones generales:",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#015796")),
                  textAlign: TextAlign.left),
            ),
            TextFormField(
                controller: _controllerobs,
                onFieldSubmitted: (v) {},
                maxLines: 4,
                decoration: InputDecoration(
                    hintText:
                        'Por favor ingrese las observaciones generales del acta',
                    hintStyle: TextStyle(color: Colors.white30),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(new Radius.circular(25.0))),
                    labelStyle: TextStyle(color: Colors.black)),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                onChanged: (valor) {
                  observaciones = valor;
                }),
            ListTile(
              onTap: () async {
                _subirfotografia(1);
              },
              leading: CircleAvatar(
                backgroundColor:
                    foto_panoramica ? Colors.blueAccent : Colors.orangeAccent,
                child: Icon(Icons.camera_alt),
                foregroundColor: Colors.white,
              ),
              title: Text('Fotografía panoramica dcfdf'),
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

  Future<bool> _procesarImagen(ImageSource origen) async {
    bool resp = false;
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    //foto = await ImagePicker.pickImage(source: origen);
    /*if (foto != null) {
      resp = true;
    } else {
      resp = false;
    }
    print("Tomo foto");*/
    return resp;
  }

  Widget _tipoluminaria() {
    return Center(
      child: DropdownSearch<ModelTipoluminaria>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 300,
        items: tipolumin,
        label: "Tipo de luminaria",
        onChanged: (ModelTipoluminaria data) {
          _tipolumi = data.tipo;
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Tipo de luminaria",
        ),
        popupTitle: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Seleccione Tipo de luminaria',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _potencialuminaria() {
    return Center(
      child: DropdownSearch<ModelPotencialuminaria>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 300,
        items: potencialumin,
        label: "Potencia de luminaria",
        onChanged: (ModelPotencialuminaria data) {
          _potencialumi = data.potencia;
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Potencia de luminaria",
        ),
        popupTitle: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Seleccione Potencia de luminaria',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _estadoluminaria() {
    return Center(
      child: DropdownSearch<ModelEstadoluminaria>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 300,
        items: estadolumi,
        label: "Estado de luminaria",
        onChanged: (ModelEstadoluminaria data) {
          _estadolumi = data.estado;
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Estado de luminaria",
        ),
        popupTitle: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Seleccione Estado de luminaria',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _valorluminaria() {
    return Center(
      child: DropdownSearch<ModelValorizacionluminaria>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 300,
        items: valorizacionlumi,
        label: "Valorización de luminaria",
        onChanged: (ModelValorizacionluminaria data) {
          _valorizacionlumi = data.valor;
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Valorización de luminaria",
        ),
        popupTitle: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Seleccione Valorización de luminaria',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Future<bool> _guardarInformacion(BuildContext context) async {
    //Estados luminarias
    // - 1 edicion luminaria
    // - 2 nueva luminaria
    // - 3 enviada luminaria
    // print("consulta ------>");
    if (_tipolumi == "") {
      show(context, "Alerta", "Por favor ingrese el tipo de luminaria", 2);
      return false;
    }
    if (_estadolumi == "") {
      show(context, "Alerta", "Por favor ingrese el estado de la luminaria", 2);
      return false;
    }
    if (_potencialumi == "") {
      show(context, "Alerta", "Por favor ingrese la potencia de la luminaria",
          2);
      return false;
    }
    if (_valorizacionlumi == "") {
      show(context, "Alerta",
          "Por favor ingrese la valorizacion de la luminaria", 2);
      return false;
    }
    print("Guarda ------->" + _estadolumi);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now) +
        " ${now.hour}:${now.minute}:${now.second}";
    ModelLuminaria nueva = ModelLuminaria.fromJson({
      "id": 0,
      "idapoyo": prefs.idapoyotrabajar,
      "tipo": _tipolumi,
      "tipootros": "",
      "potencia": _potencialumi,
      "potenciaotros": _valorizacionlumi,
      "estadoluminaria": _estadolumi,
      "lat": prefs.latitudapoyo.toString(),
      "lon": prefs.longitudapoyo.toString(),
      "observacion": observaciones,
      "fechaRegistro": formattedDate,
      "idot": prefs.idotpref
    });
    await _bd.guardarAlumbrado(nueva);
    return true;
  }
}
