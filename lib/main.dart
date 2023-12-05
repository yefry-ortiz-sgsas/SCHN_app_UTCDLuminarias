import 'package:camera/camera.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:inventario_luminarias/pagina/asignacionesot.dart';
import 'package:inventario_luminarias/pagina/gestionOT.dart';
import 'package:inventario_luminarias/pagina/login.dart';
import 'package:inventario_luminarias/pagina/mapa.dart';
import 'package:inventario_luminarias/pagina/perfil.dart';
import 'package:inventario_luminarias/pagina/principal.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inventario_luminarias/preferencias/sincronizacion.dart';
import 'package:inventario_luminarias/servicios/pushnotification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  var cron = new Cron();
  cron.schedule(new Schedule.parse('*/4 * * * *'), () async {
    print('se ejecuta cada 4 minutos.');
    SolSincronizacion().getpendientes();
  });

  var cron2 = new Cron();
  cron2.schedule(new Schedule.parse('*/6 * * * *'), () async {
    print('se ejecuta cada 6 minutos.');
    SolSincronizacion().getpendientesimagenes();
  });

  

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final prefs = new PreferenciasUsuario();

  final log = "";

  @override
  void initState() {
    super.initState();
    _generatoken();
  }

  void _generatoken() async {
    final pushProvider = new Pushnotifications();
    await pushProvider.initNotification();
    print("Token valor-->" + prefs.pushtoken);
    pushProvider.mensajesStream.listen((argumento) {
      String arg = argumento['data']['accion'];
      String os = argumento['data']['os'];
      String mensaje = argumento['data']['mensaje'];
      if (arg == "1") {}
      print("Desde main----->" + arg);
    });
  }

  @override
  Widget build(BuildContext context) {
    //prefs.inicio = 'login';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ENEE UTCD',
      initialRoute: prefs.inicio,
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'homeuser': (BuildContext context) => HomePage(),
        'perfil': (BuildContext context) => PerfilPage(),
        'mapa': (BuildContext context) => MapaGestion(),
        'gestionOT': (BuildContext context) => GestionOT(),
        'gestionAsignacionesOT': (BuildContext context) =>
            GestionAsignacionesOT(),
      },
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // Spanish
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('es'),
    );
  }
}
