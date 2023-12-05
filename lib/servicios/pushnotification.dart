import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';

class Pushnotifications {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final prefs = new PreferenciasUsuario();
  final _mensajesStreamController = StreamController<Map>.broadcast();

  Stream<Map> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    }
  }

  // Or do other work.
  initNotification() async {
    await firebaseMessaging.requestNotificationPermissions();
    final token = await firebaseMessaging.getToken();
    print("Token generado: ---->" + token);
    prefs.pushtoken = token;

    firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print('Mensaje:---> $message');
    _mensajesStreamController.sink.add(message);
    final argumento = message['data']['valor'];
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('Mensaje:---> $message');
    final argumento = message['data']['valor'];
    _mensajesStreamController.sink.add(message);
    print("Onlunch----->" + argumento.toString());
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('Mensaje:---> $message');
    final argumento = message['data']['valor'];
    _mensajesStreamController.sink.add(message);
    print("ONresuemn----->" + argumento.toString());
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
