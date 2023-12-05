import 'package:flutter/material.dart';
import 'package:inventario_luminarias/componentes/responsive.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGpsPage extends StatefulWidget {
  @override
  _AccesoGpsLinkerPageState createState() => _AccesoGpsLinkerPageState();
}

class _AccesoGpsLinkerPageState extends State<AccesoGpsPage>
    with WidgetsBindingObserver {
  final _color1 = HexColor("#FFC300");  //#fba115
  final _color2 = HexColor("#5FD0DF"); //#015796
  final prefs = new PreferenciasUsuario();
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, 'homeuser');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Luminarias'),
        backgroundColor: _color1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/imagenes/icon_1.png',
                height: _height / 3.5,
                width: _width / 3.5,
              ),
            ),
            Text(
                'Para poder brindarle una mejor experiencia y que pueda tener un mejor acceso a la información, necesitamos el acceso a su GPS.'),
            SizedBox(height: 10.0),
            MaterialButton(
                child: Text('Brindar Acceso a GPS',
                    style: TextStyle(color: Colors.white)),
                color: Colors.black,
                shape: StadiumBorder(),
                elevation: 0,
                splashColor: Colors.transparent,
                onPressed: () async {
                  final status = await Permission.location.request();
                  this.accesoGPS(status);
                })
          ],
        )),
      ),
    );
  }

  void accesoGPS(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        await Navigator.pushReplacementNamed(context, 'homeuser');
        break;
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        show(context, "Alerta", "Por favor active el GPS.", 3);
        openAppSettings();
        break;
      case PermissionStatus.limited:
        // TODO: Handle this case.
        break;
    }
  }
}
