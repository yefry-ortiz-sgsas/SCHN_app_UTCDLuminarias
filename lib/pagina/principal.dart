import 'package:auto_size_text/auto_size_text.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:custom_sheet/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:inventario_luminarias/modelos/modelResumen.dart';
import 'package:inventario_luminarias/pagina/accesoGPS.dart';
import 'package:inventario_luminarias/preferencias/estilos.dart';
import 'package:inventario_luminarias/preferencias/navegar_fadein.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:inventario_luminarias/servicios/servicios.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _color1 = HexColor("#FFC300");  //#fba115
  final _color2 = HexColor("#5FD0DF"); //#015796
  final prefs = new PreferenciasUsuario();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String fechaactual = "";
  bool _carga = true;
  CustomSheet _sheet;
  int finalizadas = 0;
  int pendientes = 0;
  int asignadas = 0;
  final _bd = new DBAsignaciones();

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    checkGpsYLocation(context);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  Drawer _menu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                color: _color1,
                image: DecorationImage(
                    image: AssetImage('assets/imagenes/Isotipo_Mesa.png'))),
          ),
          ListTile(
            leading: Icon(Icons.work, color: Colors.blue),
            title: Text('Ordenes de trabajo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'gestionOT');
              //_actualizaTrabajo();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.blue),
            title: Text('Mi información'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'perfil');
              //salir();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.supervised_user_circle, color: Colors.blue),
            title: Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context);
              prefs.sesion = 'N';
              prefs.inicio = 'login';
              Navigator.pushNamed(context, 'login');
              //_cerrarsesion();
              //salir();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carga) {
      _carga = false;
      var now = DateTime.now();
      fechaactual = DateFormat('dd/MM/yyyy').format(now);
    }

    final screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil().init(constraints, orientation);
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              centerTitle: true,
              backgroundColor: _color1,
              automaticallyImplyLeading: false,
              title: Text('Luminarias'),
            ),
            key: _scaffoldKey,
            drawer: _menu(context),
            body: Stack(children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildHeader(screenHeight, context)),
              Positioned(
                  top: 10.0.h,
                  left: 0,
                  right: 0,
                  child: _cartapresentacion(screenHeight, context)),
              _menuopciones(context)
            ]));
      });
    });
  }

  Widget _cartapresentacion(double screenHeight, BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            child: Card(
                color: Color(0xffeeeeee),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 40, bottom: 0, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Sector: " + prefs.sector, style: homextStyle),
                          SizedBox(height: 1.0.h),
                          Text("Asigandas: " + asignadas.toString(),
                              style: homextStyle),
                          SizedBox(height: 1.0.h),
                          Text("Finalizadas: " + finalizadas.toString(),
                              style: homextStyle),
                          SizedBox(height: 1.0.h),
                          Text("Pendientes: " + pendientes.toString(),
                              style: homextStyle),
                          SizedBox(height: 1.0.h),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
        Positioned(
            top: 2.0.h, child: circularImageWithBorder(30, 2, Colors.black)),
        Positioned(
            right: 2.0.h,
            top: 2.0.h,
            child: RaisedButton(
              textColor: Colors.white,
              color: _color1,
              child: Text(
                "RESUMEN",
                style: subtitulo1Styleselec,
              ),
              onPressed: () async {
                show(context, "Alerta", "Información del trabajo asignado.", 1);
              },
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            )),
        //_menuopciones(context)
      ],
    );
  }

  Widget circularImageWithBorder(
      double rad, double borderWidth, Color borderColor) {
    return CircleAvatar(
        radius: rad + borderWidth,
        backgroundColor: borderColor,
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/imagenes/trabajo.png'),
          radius: rad,
        ));
  }

  Widget _buildHeader(double screenHeight, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: _color2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Center(
                      child: AutoSizeText(
                        prefs.usuario,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0.sp,
                        ),
                        maxLines: 1,
                        minFontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Container _menuopciones(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 288),
      child: GridView.count(
          padding: EdgeInsets.all(20),
          crossAxisCount: 3,
          physics: BouncingScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _item('Asignaciones', 'assets/menu/entrega.png', 0),
            _item('Cargar asignaciones', 'assets/menu/updasignaciones.png', 2),
            _item('Mi perfil', 'assets/menu/perfil.png', 4),
            _item('Cerrar sesion', 'assets/menu/buscar.png', 5),
          ]),
    );
  }

  Card _item(String item, String img, int ac) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          if (ac == 0) {
            Navigator.pushReplacementNamed(context, 'gestionOT');
          }
          if (ac == 1) {
            Navigator.pushNamed(context, 'pendiente');
          }
          if (ac == 2) {
            _actualizaAsignacion(context);
          }
          if (ac == 3) {}
          if (ac == 4) {
            Navigator.pushNamed(context, 'perfil');
          }
          if (ac == 5) {
            prefs.sesion = 'N';
            prefs.inicio = 'login';
            Navigator.pushNamed(context, 'login');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(width: size.width * 0.15, image: AssetImage(img)),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoading(BuildContext context,
      {String text,
      Color color,
      Color textColor,
      bool dissmissable = false,
      bool draggable = false,
      bool block = true}) async {
    _sheet = CustomSheet(context, sheetColor: color, textColor: textColor);
    _sheet.showLoading(
        isDismissible: dissmissable,
        loadingMsg: text,
        enableDrag: draggable,
        block: block);
  }

  void _actualizaAsignacion(BuildContext context) async {
    Solicitudes solprincipal = new Solicitudes();
    _showLoading(context,
        text: "Cargando Asignaciones, espere por favor...", color: _color1);
    await solprincipal
        .cargaAsiganciones()
        .then((value) => print("resultado trabajo: $value"));
    Navigator.of(context).pop();
    _showLoading(context,
        text: "Cargando Apoyos, espere por favor...", color: _color1);
    await solprincipal
        .cargaAsigancionesApoyos()
        .then((value) => print("resultado postes: $value"));
    Navigator.of(context).pop();
    _validaexitencia();
    _cargaresumen();
    show(context, "Alerta", "Información actualizada.", 2);
  }

  void _cargaresumen() async {
    ModelResumen resumen = await _bd.resumen(prefs.idusuario);
    setState(() {
      pendientes = resumen.pendientes;
      finalizadas = resumen.finalizadas;
      asignadas = resumen.asignadas;
    });
  }

  void _validaexitencia() async {
    if (await ConnectionVerify.connectionStatus()) {
      Solicitudes solprincipal = new Solicitudes();
      _showLoading(context,
          text: "Actualizando asignaciones, espere por favor...",
          color: _color1);
      await solprincipal
          .eliminaAsiganciones()
          .then((value) => print("resultado trabajo: $value"));
      Navigator.of(context).pop();
    }
  }

  void checkGpsYLocation(BuildContext context) async {
    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    // GPS está activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (permisoGPS && gpsActivo) {
      //registrovehiculo
      getLocation().then((result) {
        _cargaresumen();
      });
      //
    } else if (!permisoGPS) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoGpsPage()));
    } else {
      show(context, "Alerta", "Por favor active el GPS.", 3);
    }
  }
}
