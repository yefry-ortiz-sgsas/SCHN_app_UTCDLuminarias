import 'package:custom_sheet/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:inventario_luminarias/componentes/custom_shape.dart';
import 'package:inventario_luminarias/componentes/responsive.dart';
import 'package:inventario_luminarias/preferencias/estilos.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';
import 'package:inventario_luminarias/preferencias/utilidades.dart';
import 'package:inventario_luminarias/servicios/servicios.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  final _color1 = HexColor("#FFC300");  //#fba115
  final _color2 = HexColor("#015796"); //#015796
  String _usuario = "";
  String _con = "";
  final focuspas = FocusNode();
  CustomSheet _sheet;
  bool _obscureText = true;

  final prefs = new PreferenciasUsuario();

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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(body: _principal(context));
  }

  Widget clipShape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //double height = MediaQuery.of(context).size.height;
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.1)),
    );
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 3
                  : (_medium ? _height / 2.75 : _height / 2.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color1, _color2],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 3
                  : (_medium ? _height / 2.75 : _height / 2.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color1, _color2],
                ),
              ),
            ),
          ),
        ),
        Positioned(top: 90.0, child: circulo),
        Positioned(top: 20.0, left: (size.width * 0.8) - 10, child: circulo),
        Positioned(bottom: 10.0, left: (size.width * 0.8) - 60, child: circulo),
        Positioned(
            top: 5.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              'assets/imagenes/icon_1.png',
              height: _height / 3.0,
              width: _width / 3.0,
            )),
      ],
    );
  }

  SingleChildScrollView _principal(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            clipShape(context),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Usuario:",
                      style: labelStylebold, textAlign: TextAlign.left),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                      controller: emailController,
                      onChanged: (valor) {
                        _usuario = valor;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focuspas);
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Ingrese su usuario.",
                          suffixIcon: Icon(
                            Icons.verified_user,
                            color: _color1,
                          ),
                          hintStyle: TextStyle(color: Colors.white30),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _color1,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(new Radius.circular(15.0)),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: _color1),
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(15.0))),
                          labelStyle: TextStyle(color: Colors.black)),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: 'Multi')),
                  SizedBox(height: size.height * 0.03),
                  Text("Contraseña",
                      style: labelStylebold, textAlign: TextAlign.left),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                      onChanged: (valor) {
                        _con = valor;
                      },
                      controller: passwordController,
                      onFieldSubmitted: (v) {
                        _iniciar(context);
                      },
                      focusNode: focuspas,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: "Ingrese su contraseña.",
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: _color1,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }),
                          hintStyle: TextStyle(color: Colors.white30),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _color1,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(new Radius.circular(15.0)),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: _color1, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(15.0))),
                          labelStyle: TextStyle(color: Colors.black)),
                      textAlign: TextAlign.start,
                      obscureText: _obscureText,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: 'Multi')),
                  SizedBox(height: size.height * 0.03),
                  Center(
                    child: Container(
                      height: size.height * 0.06,
                      child: RaisedButton(
                        onPressed: () {
                          _iniciar(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _color2,
                                  _color2,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Iniciar sesion",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'Multi'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _iniciar(BuildContext context) async {
    if (_usuario == "" || _con == "") {
      show(context, "Alerta",
          "Dede ingresar su usuario y ocntraseña, por favor.", 2);
    } else {
      _showLoading(context, text: "Espere por favor...", color: _color1);
      //calculandoAlertaMensaje(context, "Espere por favor...");
      int resp =
          await Solicitudes().logUsuario(_usuario, _con, prefs.pushtoken);
      if (resp == 0) {
        Navigator.of(context).pop();
        show(context, "Alerta", "Credenciales incorrectas.", 2);
      }

      if (resp == 1) {
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, 'homeuser');
      }

      if (resp == -1) {
        show(context, "Alerta",
            "Ocurrio un problema con su solicitud intentelo, mas tarde.", 2);
        Navigator.of(context).pop();
      }
    }
  }
}
