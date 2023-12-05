import 'package:custom_sheet/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:inventario_luminarias/preferencias/configuraciones.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:inventario_luminarias/preferencias/uso_color.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  CustomSheet _sheet;
  final _colorload = HexColor("#0261a0");
  final _color1 = HexColor("#FFC300");  //#fba115
  final _color2 = HexColor("#5FD0DF"); //#015796
  bool _firstTime = true;
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
    //if (!(dissmissable || draggable)) customSheet.dismiss(milliseconds: 3000);
  }

  final prefs = new PreferenciasUsuario();
  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    _firstTime = true;
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      _firstTime = false;
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Luminarias UTCD'),
          backgroundColor: _color1,
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [_background(context), _content(context)],
        ));
  }

  Container _background(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.2,
              child: Center(
                child: Image(
                  fit: BoxFit.cover,
                  width: size.width * 0.7,
                  image: AssetImage('assets/imagenes/Isotipo_Mesa.png'),
                ),
              ),
            )
          ],
        ),
        painter: _HeaderWavePainter(),
      ),
    );
  }

  Container _content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.3,
          ),
          Text(
            'Usuario: ' + prefs.usuario,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'OpenSans',
            ),
          ),
          Text(
            'Version app: ' + Configuraciones().versionapp,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'OpenSans',
            ),
          ),
          Text(
            'Ambiente: ' + Configuraciones().ambiente,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'OpenSans',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Token: ' + prefs.pushtoken,
            style: TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
          Center(
            child: Text(
              'Derechos Reservados. Licenciado a ENEE UTCD. SOLUCIONES GLOBALES 2023  ©',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = new Paint();

    // Propiedades
    lapiz.color = HexColor("#015796");
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 20;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.30,
        size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.20, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
