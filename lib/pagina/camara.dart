import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/providers/db_asignaciones.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' show join;
import 'dart:io' as Io;

class CamaraVentana extends StatefulWidget {
  @override
  _CamaraVentanaState createState() => _CamaraVentanaState();
}

class _CamaraVentanaState extends State<CamaraVentana> {
  var firstCamera;
  final _bd = new DBAsignaciones();
  final prefs = new PreferenciasUsuario();
  //camara
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    prefs.actividadgen = -1;
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    _data();
  }

  void _data() async {
    // crear un CameraController.
    final cameras = await availableCameras();
    firstCamera = cameras.first;
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      firstCamera,
      // Define la resolución a utilizar
      ResolutionPreset.medium,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fotografía'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                prefs.actividadgen = -1;
                Navigator.pop(context);
              }),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Si el Future está completo, muestra la vista previa
              return CameraPreview(_controller);
            } else {
              // De lo contrario, muestra un indicador de carga
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              var pathq = await _controller.takePicture();
              String path = pathq.path.toString();
              print("proceso imagen");
              bool img = await guardarImagen(prefs.idapoyotrabajar,
                  prefs.idotpref, path, prefs.actividadgen);
              print("guardo imagen " + img.toString());
              if (img) {
                prefs.actividadgen = 0;
                Navigator.pop(context);
              }
            } catch (e) {
              prefs.actividadgen = -1;
              Navigator.pop(context);
              print(e);
            }
          },
        ));
  }
}
