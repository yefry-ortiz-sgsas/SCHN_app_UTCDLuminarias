import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del Usuario
  get pushtoken {
    return _prefs.getString('pushtoken') ?? '';
  }

  set pushtoken(String value) {
    _prefs.setString('pushtoken', value);
  }

  get inicio {
    return _prefs.getString('inicio') ?? 'login';
  }

  set inicio(String value) {
    _prefs.setString('inicio', value);
  }

  get usuario {
    return _prefs.getString('usuario') ?? '';
  }

  set usuario(String value) {
    _prefs.setString('usuario', value);
  }

  get sesion {
    return _prefs.getString('sesion') ?? 'N';
  }

  set sesion(String value) {
    _prefs.setString('sesion', value);
  }

  get sector {
    return _prefs.getString('sector') ?? '';
  }

  set sector(String value) {
    _prefs.setString('sector', value);
  }

  get codsector {
    return _prefs.getString('codsector') ?? '';
  }

  set codsector(String value) {
    _prefs.setString('codsector', value);
  }

  get idusuario {
    return _prefs.getInt('idusuario') ?? '';
  }

  set idusuario(int value) {
    _prefs.setInt('idusuario', value);
  }

  get idotpref {
    return _prefs.getInt('idotpref') ?? 0;
  }

  set idotpref(int value) {
    _prefs.setInt('idotpref', value);
  }

  get idapoyotrabajar {
    return _prefs.getInt('idapoyotrabajar') ?? '';
  }

  set idapoyotrabajar(int value) {
    _prefs.setInt('idapoyotrabajar', value);
  }

  get idapoyotempo {
    return _prefs.getInt('idapoyotempo') ?? '';
  }

  set idapoyotempo(int value) {
    _prefs.setInt('idapoyotempo', value);
  }

  get trabajoactivo {
    return _prefs.getBool('trabajoactivo') ?? false;
  }

  set trabajoactivo(bool value) {
    _prefs.setBool('trabajoactivo', value);
  }

  get latitudmover {
    return _prefs.getDouble('latitudmover') ?? 0;
  }

  set latitudmover(double value) {
    _prefs.setDouble('latitudmover', value);
  }

  get longitudmover {
    return _prefs.getDouble('longitudmover') ?? 0;
  }

  set longitudmover(double value) {
    _prefs.setDouble('longitudmover', value);
  }

  get latitudapoyo {
    return _prefs.getDouble('latitudapoyo') ?? 0;
  }

  set latitudapoyo(double value) {
    _prefs.setDouble('latitudapoyo', value);
  }

  get longitudapoyo {
    return _prefs.getDouble('longitudapoyo') ?? 0;
  }

  set longitudapoyo(double value) {
    _prefs.setDouble('longitudapoyo', value);
  }

  get actividadgen {
    return _prefs.getInt('actividadgen') ?? 0;
  }

  set actividadgen(int value) {
    _prefs.setInt('actividadgen', value);
  }
}
