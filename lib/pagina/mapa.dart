import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventario_luminarias/modelos/latlon_modelo.dart';
import 'package:inventario_luminarias/modelos/modelApoyo.dart';
import 'package:inventario_luminarias/modelos/modelLuminaria.dart';
import 'package:inventario_luminarias/pagina/cierreApoyo.dart';
import 'package:inventario_luminarias/pagina/nuevaLuminaria.dart';
import 'package:inventario_luminarias/pagina/nuevoapoyo.dart';
import 'package:inventario_luminarias/preferencias/estilos.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'dart:io' as Io;

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MapaGestion extends StatefulWidget {
  @override
  _MapaGestionState createState() => _MapaGestionState();
}

class _MapaGestionState extends State<MapaGestion> {
  List<String> fotos = <String>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _color1 = HexColor("#F29100"); //fba115
  Io.File foto;
  bool _botones = true;
  MapboxMapController mapController;
  int acuse = 0;
  final _bd = new DBAsignaciones();
  String mapabase =
      'mapbox://styles/wmaradiaga202018/ckdry2evk009019mhkktwy2tn';
  final style_satelitte =
      'mapbox://styles/wmaradiaga202018/ckdry977e0fn61ao9yi8mfwuq';
  final style_basico =
      'mapbox://styles/wmaradiaga202018/ckdry2evk009019mhkktwy2tn';
  bool _firstTime;
  MyLocationTrackingMode _myLocationTrackingMode =
      MyLocationTrackingMode.Tracking;
  bool _myLocationEnabled = true;
  final center = LatLng(14.080512, -87.21252);
  final prefs = new PreferenciasUsuario();
  bool barra = false;
  Map<String, String> apoyoseleccionado = {
    "idot": "",
    "circuito": "",
    "estado": "",
    "pintadoapoyo": "",
    "idapoyo": "",
    "lon": "",
    "fecharegistro": "",
    "lat": "",
    "apoyotemporal": "",
    "idusuario": "",
  };
  Circle _selectedCircle;
  double latitudmarker = 0;
  double longitudmarker = 0;
  bool _fechafiltro = false;
  bool _nuevocliente = false;
  bool _sinapoyo = true;
  bool _nuevoapoyo = false;
  ScrollController _scrollController = new ScrollController();

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    salir();
    return true;
  }

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    prefs.trabajoactivo = false;
    super.initState();
    _firstTime = true;
    _pendientes();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    mapController.onCircleTapped.remove(_onCircleTapped);
    super.dispose();
  }

  void salir() async {
    Navigator.pushReplacementNamed(context, 'gestionAsignacionesOT');
  }

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      //_firstTime = false;
      //_trabajo = false;
      //tipo = "";
      //print("Trabajo falso");
      getLocation().then((result) {
        //setState(() {});
      });
    }

    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Luminarias'),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.map_sharp),
                    onPressed: () {
                      if (mapabase == style_basico) {
                        mapabase = style_satelitte;
                      } else {
                        mapabase = style_basico;
                      }
                      setState(() {});
                    },
                  ),
                  Visibility(
                    visible: !_nuevoapoyo,
                    child: IconButton(
                      icon: Icon(
                        Icons.expand,
                        size: 5.0.h,
                      ),
                      onPressed: () {
                        if (!prefs.trabajoactivo) {
                          setState(() {
                            _nuevoapoyo = true;
                            _nuevocliente = true;
                            _sinapoyo = false;
                          });
                          show(
                              context,
                              "Alerta",
                              "Se activo la funcion de registrar un apoyo nuevo.",
                              1);
                        } else {
                          show(context, "Alerta",
                              "Finalice la edicion del apoyo actual.", 2);
                        }
                      },
                    ),
                  ),
                  Visibility(
                      visible: _nuevoapoyo,
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 5.0.h,
                        ),
                        color: Colors.yellow,
                        onPressed: () {
                          if (!prefs.trabajoactivo) {
                            setState(() {
                              _nuevoapoyo = false;
                              _nuevocliente = false;
                              _sinapoyo = true;
                            });
                          }
                        },
                      ))
                ],
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => salir()),
              ),
              body: Stack(children: [
                crearMapa(),
                Visibility(visible: _fechafiltro, child: _seccion(context)),
                Visibility(
                    visible: barra,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: !_nuevocliente
                          ? Container(
                              height: 7.0.h,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _nuevocliente = true;
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LuminariaNueva()))
                                                .then((value) async {
                                              setState(() {
                                                _nuevocliente = false;
                                              });
                                            });
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 22.0,
                                        ),
                                        label: Text('Registrar Luminarias'),
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder()),
                                      ),
                                    ),
                                    // Visibility(
                                    //   visible: _sinapoyo,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(5.0),
                                    //     child: ElevatedButton.icon(
                                    //       onPressed: () {
                                    //         setState(() {
                                    //           _nuevoapoyo = true;
                                    //           _nuevocliente = false;
                                    //           _sinapoyo = false;
                                    //         });
                                    //         show(
                                    //             context,
                                    //             "Alerta",
                                    //             "Se activo la funcion de registrar un apoyo nuevo.",
                                    //             2);
                                    //       },
                                    //       icon: Icon(
                                    //         Icons.add,
                                    //         color: Colors.white,
                                    //         size: 22.0,
                                    //       ),
                                    //       label: Text('Registrar Apoyo'),
                                    //       style: ElevatedButton.styleFrom(
                                    //           shape: StadiumBorder()),
                                    //     ),
                                    //   ),
                                    // ),

                                    Visibility(
                                      visible: _sinapoyo,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            prefs.idapoyotempo = -12;
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LuminariacierreNueva()))
                                                .then((value) async {
                                              if (prefs.idapoyotempo == -2) {
                                                show(
                                                    context,
                                                    "Resultado",
                                                    "Información guardada, con éxito.",
                                                    1);
                                                setState(() {
                                                  _fechafiltro = false;
                                                  prefs.trabajoactivo = false;
                                                  barra = false;
                                                  _botones = true;
                                                  prefs.idapoyotrabajar = 0;
                                                  prefs.idapoyotempo = -1;
                                                });
                                                refreshdata();
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.report_off,
                                            color: Colors.white,
                                            size: 22.0,
                                          ),
                                          label: Text('No se puede registrar.'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.brown,
                                              shape: StadiumBorder()),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _sinapoyo,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            prefs.idapoyotempo = -10;
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LuminariacierreNueva()))
                                                .then((value) async {
                                              if (prefs.idapoyotempo == -2) {
                                                show(
                                                    context,
                                                    "Resultado",
                                                    "Información guardada, con éxito.",
                                                    1);
                                                setState(() {
                                                  _fechafiltro = false;
                                                  prefs.trabajoactivo = false;
                                                  barra = false;
                                                  _botones = true;
                                                  prefs.idapoyotrabajar = 0;
                                                  prefs.idapoyotempo = -1;
                                                });
                                                refreshdata();
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.report_off,
                                            color: Colors.white,
                                            size: 22.0,
                                          ),
                                          label: Text('No existen luminarias.'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.orangeAccent,
                                              shape: StadiumBorder()),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _sinapoyo,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            cancelartrabajo();
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                            size: 22.0,
                                          ),
                                          label: Text('Cancelar trabajo'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.indigo,
                                              shape: StadiumBorder()),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _sinapoyo,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            finalizartrabajo();
                                          },
                                          icon: Icon(
                                            Icons.done_all,
                                            color: Colors.white,
                                            size: 22.0,
                                          ),
                                          label: Text('Finalizar trabajo'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              shape: StadiumBorder()),
                                        ),
                                      ),
                                    ),
                                  ]),
                            )
                          : Container(
                              height: 7.0.h,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _nuevocliente = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 22.0,
                                        ),
                                        label: Text('Cancelar nuevo Luminaria'),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            shape: StadiumBorder()),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _nuevoapoyo,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _sinapoyo = true;
                                              _nuevoapoyo = false;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 22.0,
                                          ),
                                          label: Text('Cancelar nuevo apoyo'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              shape: StadiumBorder()),
                                        ),
                                      ),
                                    ),
                                  ])),
                    )),
              ]),
              floatingActionButton:
                  Visibility(child: botonesmapa(), visible: _botones),
            );
          },
        );
      },
    );
  }

  Column botonesmapa() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // ZoomIn
        FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add, size: 32),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            }),

        SizedBox(height: 5),

        // ZoomOut
        FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.remove, size: 32),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            }),

        SizedBox(height: 5),
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: mapabase,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 18),
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {},
      onMapLongClick: (point, latLng) async {
        if (_nuevoapoyo) {
          nuevoapoyo(latLng.latitude, latLng.longitude);
        }
      },
    );
  }

  void nuevoapoyo(double lat, double lng) {
    prefs.latitudapoyo = lat;
    prefs.longitudapoyo = lng;
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => ApoyoNuevo()))
        .then((value) async {
      setState(() {
        _nuevoapoyo = false;
        _nuevocliente = false;
        _sinapoyo = true;
        if (prefs.idapoyotempo == -2) {
          _pendientesmarker();
        }
      });
    });
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    //mapController.onSymbolTapped.add(_onSymbolTapped);
    //mapController.onLineTapped.add(_onLineTapped);
    mapController.onCircleTapped.add(_onCircleTapped);
  }

  void _pendientes() async {
    //_add("assets/images/location.png");
    await Future.delayed(Duration(milliseconds: 4000));
    if (prefs.latitudmover != 0 && prefs.longitudmover != 0) {
      mapController
          .animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0.0,
                target: LatLng(prefs.latitudmover, prefs.longitudmover),
                tilt: 30.0,
                zoom: 22.0,
              ),
            ),
          )
          .then((result) =>
              print("mapController.animateCamera() returned $result"));
    }
    _pendientesmarker();
  }

  void _pendientesmarker() async {
    await mapController.clearCircles();
    int idu = prefs.idusuario;
    List<ModelApoyo> listapendientes = new List<ModelApoyo>();
    listapendientes = await _bd.getAsignacionesOTStemp(prefs.idotpref);
    for (int i = 0; i < listapendientes.length; i++) {
      ModelApoyo fila = listapendientes[i];
      Map<String, String> map = {
        "idot": fila.idot.toString(),
        "circuito": fila.circuito,
        "estado": fila.estado,
        "pintadoapoyo": fila.pintadoapoyo,
        "idapoyo": fila.idapoyo.toString(),
        "lon": fila.lon.toString(),
        "fecharegistro": fila.fecharegistro,
        "lat": fila.lat.toString(),
        "apoyotemporal": fila.apoyotemporal.toString(),
        "idusuario": fila.idusuario.toString()
      };

      String color = "#d0ff00";

      switch (fila.estado) {
        case "Pendiente":
          color = "#eaff00";
          if (fila.apoyotemporal != -12 &&
              fila.apoyotemporal != -10 &&
              fila.apoyotemporal != 0) {
            color = "#ffa200";
          }
          break;
        case "Finalizada":
          color = "#00cc44";
          if (fila.apoyotemporal == -12) {
            color = "#ff0000";
          }
          if (fila.apoyotemporal != -12 &&
              fila.apoyotemporal != -10 &&
              fila.apoyotemporal != 0) {
            color = "#ffa200";
          }
          break;
        case "Enviada":
          color = "#00cc44";
          if (fila.apoyotemporal == -12) {
            color = "#ff0000";
          }
          if (fila.apoyotemporal != -12 &&
              fila.apoyotemporal != -10 &&
              fila.apoyotemporal != 0) {
            color = "#ffa200";
          }
          break;
      }

      // print("Est: " + fila.estado + " " + color);

      mapController.addCircle(
          CircleOptions(
              circleRadius: 10,
              circleOpacity: 1,
              geometry: LatLng(
                fila.lat,
                fila.lon,
              ),
              circleColor: color),
          map);
    }
    setState(() {});
  }

  void _removeapoyos() async {
    await mapController.clearCircles();
    _pendientesmarker();
  }

  void _updateSelectedCircle(CircleOptions changes) {
    mapController.updateCircle(_selectedCircle, changes);
  }

  void _updateSelectedCirclecancel(CircleOptions changes) {
    mapController.updateCircle(_selectedCircle, changes);
    _selectedCircle = null;
  }

  void _onCircleTapped(Circle circle) {
    if (!_nuevoapoyo) {
      if (_selectedCircle != null) {
        _updateSelectedCircle(
          const CircleOptions(
            circleRadius: 16,
            circleOpacity: 1.0,
          ),
        );
      }
      _selectedCircle = circle;

      if (_selectedCircle.data['estado'] == "Pendiente") {
        if (prefs.trabajoactivo == false) {
          _botones = false;
          prefs.idapoyotrabajar = int.parse(_selectedCircle.data['idapoyo']);
          apoyoseleccionado = {
            "idot": _selectedCircle.data['idot'],
            "circuito": _selectedCircle.data['circuito'],
            "estado": _selectedCircle.data['estado'],
            "pintadoapoyo": _selectedCircle.data['pintadoapoyo'],
            "idapoyo": _selectedCircle.data['idapoyo'],
            "lon": _selectedCircle.data['lon'],
            "fecharegistro": _selectedCircle.data['fecharegistro'],
            "lat": _selectedCircle.data['lat'],
            "apoyotemporal": _selectedCircle.data['apoyotemporal'],
            "idusuario": _selectedCircle.data['idusuario']
          };
          double lat1 = double.parse(_selectedCircle.data['lat'].toString());
          double lng1 = double.parse(_selectedCircle.data['lon'].toString());
          latitudmarker = double.parse(_selectedCircle.data['lat'].toString());
          longitudmarker = double.parse(_selectedCircle.data['lon'].toString());
          prefs.latitudapoyo = lat1;
          prefs.longitudapoyo = lng1;
          _fechafiltro = true;
          prefs.trabajoactivo = true;
          barra = true;
        } else {
          show(context, "Alerta",
              "Finalice la edicion de un apoyo para activar el siguiente.", 2);
        }
      } else {
        show(context, "Alerta", "Apoyo ya finalizado.", 2);
      }

      setState(() {});
    } else {
      show(context, "Alerta", "Finalice la funcion de nuevo apoyo", 2);
    }
  }

  DraggableScrollableSheet _seccion(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.7,
      builder: (context, ScrollController scrollController) {
        return Container(
          child: _listaItems(context, scrollController),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
        );
      },
    );
  }

  launchURL() async {
    LatLon coord = await getLocation();
    String latp1 = coord.lat;
    String lonp1 = coord.lon;
    String latp2 = latitudmarker.toString();
    String lonp2 = longitudmarker.toString();
    final String googleMapslocationUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$latp1,$lonp1&destination=$latp2,$lonp2";

    print(googleMapslocationUrl);

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }

  SingleChildScrollView _listaItems(
      BuildContext context, ScrollController _scrollController) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    launchURL();
                  },
                  color: _color1,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.alt_route,
                    size: 18,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 0),
                child: Center(
                    child: Text(
                        " Gestión IDAPOYO: " + apoyoseleccionado['idapoyo'],
                        style: TextStyle(color: Colors.black)))),
            Divider(
              color: Colors.black,
              thickness: .2,
              indent: 8,
              endIndent: 8,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pintado apoyo: ' + apoyoseleccionado['pintadoapoyo'],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Text(
                      'Circuito: ' + apoyoseleccionado['circuito'],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 0),
                child: Center(
                    child: Text("Luminarias Registradas",
                        style: TextStyle(color: Colors.black)))),
            Divider(
              color: Colors.black,
              thickness: .2,
              indent: 8,
              endIndent: 8,
            ),
            _principalluminarias(context)
          ],
        ),
      ),
    );
  }

  Widget _principalluminarias(context) {
    int cod = prefs.idapoyotrabajar;
    return FutureBuilder<List<ModelLuminaria>>(
        future: _bd.getluminariasapoyo(cod),
        builder: (BuildContext context,
            AsyncSnapshot<List<ModelLuminaria>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final sellos = snapshot.data;
          if (sellos.length == 0) {
            return Center(
              child: Text('Luminarias no agregadas.'),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            itemCount: sellos.length,
            primary: false,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.0),
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 3, color: Colors.black),
            itemBuilder: (BuildContext context, int index) {
              ModelLuminaria fila = sellos[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                    color: Colors.blue,
                    child: Center(
                        child:
                            Text('Eliminando...', style: homextStyledelete))),
                onDismissed: (direction) {
                  eliminarLumina(fila.id);
                },
                child: ListTile(
                    title: Text(fila.tipo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Potencia: ' + fila.potencia,
                            style: GoogleFonts.lato(fontSize: 12.0)),
                        SizedBox(height: 1.0),
                        Text('Estado: ' + fila.estadoluminaria,
                            style: GoogleFonts.lato(fontSize: 12.0)),
                        SizedBox(height: 1.0),
                        Text('Valorización: ' + fila.potenciaotros,
                            style: GoogleFonts.lato(fontSize: 12.0))
                      ],
                    ),
                    trailing: Icon(
                      Icons.delete_sweep,
                      color: Colors.red,
                    )),
              );
            },
          );
        });
  }

  void eliminarLumina(int idl) async {
    try {
      int d = await _bd.eliminarluminaria(idl);
      setState(() {});
    } catch (e) {
      print("Ocurrio un error al eliminar la imagen");
    }
  }

  void finalizartrabajo() async {
    setState(() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¿Desea finalizar la edicion de este apoyo?'),
            actions: [
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  int r = await _bd.updateEstado(
                      prefs.idapoyotrabajar, "Finalizada");
                  show(context, "Resultado", "Información guardada, con éxito.",
                      1);
                  setState(() {
                    _fechafiltro = false;
                    prefs.trabajoactivo = false;
                    barra = false;
                    _botones = true;
                    prefs.idapoyotrabajar = 0;
                  });
                  refreshdata();
                },
                child: Text('Si'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              )
            ],
          );
        },
      );
    });
  }

  void cancelartrabajo() {
    setState(() {
      _fechafiltro = false;
      prefs.trabajoactivo = false;
      barra = false;
      _botones = true;
      prefs.idapoyotrabajar = 0;
    });
  }

  void refreshdata() {
    _pendientesmarker();
  }
}
