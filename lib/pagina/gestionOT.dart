import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:custom_sheet/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventario_luminarias/modelos/modelAsignaciones.dart';
import 'package:inventario_luminarias/pagina/accesoCamara.dart';
import 'package:inventario_luminarias/preferencias/navegar_fadein.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class GestionOT extends StatefulWidget {
  @override
  _GestionOTState createState() => _GestionOTState();
}

class _GestionOTState extends State<GestionOT> {
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

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    salir();
    return true;
  }

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    updatenum();
  }

  void salir() async {
    Navigator.pushReplacementNamed(context, 'homeuser');
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
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
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return Scaffold(
                backgroundColor: _colorfondo,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('Luminarias'),
                  backgroundColor: _color1,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () async {
                        salir();
                      }
                      //,
                      ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: infolinker(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          'Ordenes de trabajo'.toUpperCase(),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: _listamisenvios(),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  Widget infolinker() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [1, 0, 0],
                colors: [_color2, _color2, _color2], // Colors - Design System
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  BorderRadius.circular(25), // Dimensions - Design System
            ), // Dimensions - Design System
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.update,
                                color: Colors.white, // Colors - Design System
                                size: 5.0.h,
                              ),
                              SizedBox(
                                width: 2.0.h,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cantidadpendientes.toString().toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                          color: Colors
                                              .white, // Colors - Design System
                                          fontWeight: FontWeight.w900,
                                          height: 1.1,
                                        ),
                                  ),
                                  Text(
                                    'ORDENES DE TRABAJO PENDIENTES',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(
                                          color: Colors
                                              .white, // Colors - Design System
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listamisenvios() {
    return FutureBuilder<List<ModelOt>>(
        future: _bd.getOTS(prefs.idusuario),
        builder: (BuildContext context, AsyncSnapshot<List<ModelOt>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final sellos = snapshot.data;
          if (sellos.length == 0) {
            return Column(
              children: [
                SizedBox(height: 5.0.h),
                Center(
                  child: Text(
                      "No tiene ordenes de trabajo pendientes, por el momento.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            );
          }
          return ListView(
            controller: _scrollController,
            primary: false,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: _listaItems(snapshot.data, context),
          );
        });
  }

  List<Widget> _listaItems(List<ModelOt> data, BuildContext context) {
    final List<Widget> opciones = [];
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // setState(() {
    //   cantidadpendientes = data.length;
    // });
    cantidadpendientes = data.length;
    for (int k = 0; k < data.length; k++) {
      ModelOt fila = data[k];
      final widgetTemp = Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(25), // Dimensions - Design System
                  ), // Dimensions - Design System
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                                10), // Dimensions - Design System
                                          ),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.assignment,
                                                  color: Colors
                                                      .white, // Colors - Design System
                                                  size: 3.0.h,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 2.0.h,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'OT: ' + fila.idot.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(
                                                    color: Colors
                                                        .black54, // Colors - Design System
                                                    fontWeight: FontWeight.w900,
                                                    height: 1.1,
                                                  ),
                                            ),
                                            Text(
                                              'Fecha asignado: ' +
                                                  formatter.format(
                                                      fila.fechaasignacion),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                    color: Colors
                                                        .black54, // Colors - Design System
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              "Total asignaciones: " +
                                                  fila.asignaciones.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                    color: Colors
                                                        .black45, // Colors - Design System
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 2.0.h,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _color1,
                                        borderRadius: BorderRadius.circular(
                                            10), // Dimensions - Design System
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          prefs.idotpref = fila.idot;
                                          Navigator.pushReplacementNamed(
                                              context, 'gestionAsignacionesOT');
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                        iconSize: 3.0.h,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
      opciones..add(widgetTemp);
    }

    return opciones;
  }

  void updatenum() {
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
    checkGpsYLocation(context);
  }

  void checkGpsYLocation(BuildContext context) async {
    // PermisoGPS
    final permisoGPS = await Permission.camera.isGranted;
    // GPS está activo
    if (permisoGPS) {
    } else if (!permisoGPS) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoCamaraPage()));
    } else {
      show(context, "Alerta", "Por favor brinde acceso a la camara.", 3);
    }
  }
}
