import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventario_luminarias/modelos/modelAlturaApoyo.dart';
import 'package:inventario_luminarias/modelos/modelApoyo.dart';
import 'package:inventario_luminarias/modelos/modelApoyonuevo.dart';
import 'package:inventario_luminarias/modelos/modelTipoapoyo.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:sizer/sizer.dart';

class ApoyoNuevo extends StatefulWidget {
  @override
  _ApoyoNuevoState createState() => _ApoyoNuevoState();
}

class _ApoyoNuevoState extends State<ApoyoNuevo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _bd = new DBAsignaciones();
  final prefs = new PreferenciasUsuario();
  List<ModelAlturaApoyo> alturaapoyo = new List<ModelAlturaApoyo>();
  List<ModelTipoApoyo> tipoapoyo = new List<ModelTipoApoyo>();
  String _tipoapoyo = "";
  int _alturaapoyo;
  int _selectedIndex = 0;
  bool fotoapoyo = false;
  String path = "";

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    _data();
    super.initState();
  }

  void _data() async {
    List<ModelAlturaApoyo> lista1 = await _bd.getalturaapoyo();
    List<ModelTipoApoyo> lista2 = await _bd.gettipoapoyo();
    setState(() {
      alturaapoyo = lista1;
      tipoapoyo = lista2;
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
    prefs.idapoyotempo == -1;
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
                  title: Text('Nuevo Apoyo'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => atras(),
                  ),
                ),
                body: nuevoapoyo(context),
                bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _selectedIndex,
                    backgroundColor: HexColor("#5FD0DF"), //015796
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.done_outline, color: Colors.white),
                          title: Text('Agregar Apoyo',
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
                        prefs.idapoyotempo = -1;
                        Navigator.pop(context);
                      } else {
                        bool r = await _guardarInformacion(context);
                        if (r) {
                          show(context, "Alerta",
                              "El apoyo fue guardado, con éxito.", 1);
                          prefs.idapoyotempo = -2;
                          Navigator.pop(context);
                        }
                      }
                    }));
          },
        );
      },
    );
  }

  Widget nuevoapoyo(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 2.0.h),
            _tipolistaapoyo(),
            SizedBox(height: 2.0.h),
            _alturalistaapoyo(),
            SizedBox(height: 2.0.h),
          ],
        ),
      )
    ]);
  }

  Widget _tipolistaapoyo() {
    return Center(
      child: DropdownSearch<ModelTipoApoyo>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 300,
        items: tipoapoyo,
        label: "Tipo de apoyo",
        onChanged: (ModelTipoApoyo data) {
          _tipoapoyo = data.tipo;
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Tipo de apoyo",
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
              'Seleccione Tipo de apoyo',
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

  Widget _alturalistaapoyo() {
    return Center(
      child: DropdownSearch<ModelAlturaApoyo>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 300,
        items: alturaapoyo,
        label: "Altura de apoyo",
        onChanged: (ModelAlturaApoyo data) {
          _alturaapoyo = data.altura;
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Altura de apoyo",
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
              'Seleccione Altura de apoyo',
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
    if (_tipoapoyo == "") {
      show(context, "Alerta", "Por favor ingrese el tipo de apoyo", 2);
      return false;
    }
    if (_alturaapoyo == null) {
      show(context, "Alerta", "Por favor ingrese la altura del apoyo", 2);
      return false;
    }

    ModelApoyonuevo nueva = ModelApoyonuevo.fromJson({
      "id": 0,
      "lat": prefs.latitudapoyo,
      "lon": prefs.longitudapoyo,
      "alturaapoyo": _alturaapoyo.toString(),
      "tipoapoyo": _tipoapoyo,
      "estado": 0,
      "idot":prefs.idotpref
    });

    int id = await _bd.guardaApoyo(nueva);
    print("Guarda APOYO GENERADO------->" + id.toString());
    ModelApoyo finalg = ModelApoyo.fromJson({
      "idot": prefs.idotpref,
      "circuito": "",
      "estado": "Pendiente",
      "pintadoapoyo": "",
      "idapoyo": id,
      "lon": prefs.longitudapoyo,
      "fecharegistro": "",
      "lat": prefs.latitudapoyo,
      "apoyotemporal": id,
      "idusuario": prefs.idusuario,
      "estadoimagen":0
    });
    await _bd.nuevaasignacionApoyo(finalg);

    return true;
  }
}
