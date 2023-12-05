import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:custom_sheet/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:inventario_luminarias/modelos/modelApoyo.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GestionAsignacionesOT extends StatefulWidget {
  @override
  _GestionAsignacionesOTState createState() => _GestionAsignacionesOTState();
}

class _GestionAsignacionesOTState extends State<GestionAsignacionesOT> {
  final _color1 = HexColor("#FFC300");  //#fba115
  final _color2 = HexColor("#5FD0DF"); //#015796
  final prefs = new PreferenciasUsuario();
  final _colorfondo = HexColor("#efefef");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String fechaactual = "";
  bool _carga = true;
  CustomSheet _sheet;
  final _bd = new DBAsignaciones();
  ScrollController _scrollController = new ScrollController();
  int cantidadpendientes = 0;
  int _selectedIndex = 0;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    salir();
    return true;
  }

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  void salir() async {
    Navigator.pushReplacementNamed(context, 'gestionOT');
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('OT: ' + prefs.idotpref.toString()),
            backgroundColor: HexColor("#0261a0"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => salir(),
            )),
        body: _lista(context),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: HexColor("#015796"),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.mapMarkerPath,
                    color: Colors
                        .white), //Icon(Icons.refresh, color: Colors.white),
                title: Text('Trabajo', style: TextStyle(color: Colors.white))),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.progressClose, color: Colors.white),
                title: Text('Salir', style: TextStyle(color: Colors.white)))
          ],
          onTap: _onItemTapped,
        ));
  }

  Widget _lista(context) {
    return FutureBuilder<List<ModelApoyo>>(
        future: _bd.getAsignacionesOTS(prefs.idotpref),
        builder:
            (BuildContext context, AsyncSnapshot<List<ModelApoyo>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final os = snapshot.data;
          if (os.length == 0) {
            return Center(
              child: Text('No hay asignaciones disponibles.'),
            );
          }

          return ListView(
            children: _listaItems(snapshot.data, context),
          );
        });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, 'mapa');
    }
    if (index == 1) {
      Navigator.pushReplacementNamed(context, 'homeuser');
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _listaItems(List<ModelApoyo> data, BuildContext context) {
    final List<Widget> opciones = [];
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    for (int k = 0; k < data.length; k++) {
      ModelApoyo fila = data[k];
      Widget icono;
      if (data[k].estado == "Pendiente") {
        icono = Icon(Icons.phone_android, color: Colors.red);
      }

      if (data[k].estado == "Enviada") {
        icono = Icon(Icons.done_all, color: Colors.green);
      }

      if (data[k].estado == "Finalizada") {
        icono = Icon(Icons.alarm_on, color: Colors.blue);
      }

      if (data[k].estado == "Pendiente") {
        final widgetTemp = ListTile(
          title: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                      'PINTADO APOYO:' + data[k].pintadoapoyo.toString(),
                      style: GoogleFonts.lato(
                          fontSize: 14.0, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text('Circuito:' + data[k].circuito,
                      style: GoogleFonts.lato(fontSize: 14.0)),
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('ID Apoyo:' + fila.idapoyo.toString(),
                  style: GoogleFonts.almarai(
                      color: Colors.blue,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          leading: icono,
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            prefs.idapoyotrabajar = data[k].idapoyo;
            prefs.trabajoactivo = false;
            _enviamapa(data[k].lat, data[k].lon);
          },
        );
        opciones..add(widgetTemp)..add(Divider());
      }

      if (data[k].estado == "Enviada" || data[k].estado == "Finalizada") {
        final widgetTemp = ListTile(
          title: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                      'PINTADO APOYO:' + data[k].pintadoapoyo.toString(),
                      style: GoogleFonts.lato(
                          fontSize: 14.0, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text('Circuito:' + data[k].circuito,
                      style: GoogleFonts.lato(fontSize: 14.0)),
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('ID Apoyo:' + fila.idapoyo.toString(),
                  style: GoogleFonts.almarai(
                      color: Colors.blue,
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          leading: icono,
        );
        opciones..add(widgetTemp)..add(Divider());
      }
    }
    return opciones;
  }

  void _enviamapa(double lat, double lon) {
    prefs.latitudmover = lat;
    prefs.longitudmover = lon;
    prefs.trabajoactivo = false;
    Navigator.pushReplacementNamed(context, 'mapa');
  }
}
