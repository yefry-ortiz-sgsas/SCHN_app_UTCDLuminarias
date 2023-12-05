import 'package:inventario_luminarias/modelos/ModelPotencialuminaria.dart';
import 'package:inventario_luminarias/modelos/modelAlturaApoyo.dart';
import 'package:inventario_luminarias/modelos/modelApoyo.dart';
import 'package:inventario_luminarias/modelos/modelApoyonuevo.dart';
import 'package:inventario_luminarias/modelos/modelAsignaciones.dart';
import 'package:inventario_luminarias/modelos/modelEstadoluminaria.dart';
import 'package:inventario_luminarias/modelos/modelImagen.dart';
import 'package:inventario_luminarias/modelos/modelLuminaria.dart';
import 'package:inventario_luminarias/modelos/modelResumen.dart';
import 'package:inventario_luminarias/modelos/modelTipoLuminaria.dart';
import 'package:inventario_luminarias/modelos/modelTipoapoyo.dart';
import 'package:inventario_luminarias/modelos/modelValorizacionluminaria.dart';
import 'package:inventario_luminarias/preferencias/preferencias_usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'db_provider.dart';

class DBAsignaciones {
  final prefs = new PreferenciasUsuario();

  Future<int> existeasignacion(int id) async {
    final db = await DBProvider.db.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM Inv_AsignacionOT WHERE idot=$id'));
    return count;
  }

  //insertar
  nuevaasignacion(ModelOt os) async {
    final db = await DBProvider.db.database;
    final res = await db.insert('Inv_AsignacionOT', os.toJson());
    return res;
  }

  Future<int> existeasignacionapoyo(int idot, int idapoyo) async {
    final db = await DBProvider.db.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM Inv_ApoyosOT WHERE idot=$idot and idapoyo=$idapoyo'));
    return count;
  }

  Future<int> existeasignacionidot(int idot) async {
    final db = await DBProvider.db.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM Inv_ApoyosOT WHERE idot=$idot and idot=$idot and estado='Pendiente'"));
    return count;
  }

  //insertar
  nuevaasignacionApoyo(ModelApoyo os) async {
    final db = await DBProvider.db.database;
    final res = await db.insert('Inv_ApoyosOT', os.toJson());
    return res;
  }

  Future<ModelResumen> resumen(int idu) async {
    final db = await DBProvider.db.database;
    //print(
    //    "select (select count(*) from Inv_ApoyosOT where idusuario = $idu) as asignadas,(select count(*) from Inv_ApoyosOT where idusuario = $idu and estado='Finalizada') as finalizadas,(select count(*) from Inv_ApoyosOT where idusuario = $idu and estado='Pendiente') as pendientes");
    final res = await db.rawQuery(
        "select (select count(*) from Inv_ApoyosOT where idusuario = $idu) as asignadas,(select count(*) from Inv_ApoyosOT where idusuario = $idu and estado='Finalizada') as finalizadas,(select count(*) from Inv_ApoyosOT where idusuario = $idu and estado='Pendiente') as pendientes");
    return res.isNotEmpty ? ModelResumen.fromJson(res.first) : null;
  }

  Future<List<ModelOt>> getOTS(int idu) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "select * from Inv_AsignacionOT where id=$idu and estado='Pendiente'");
    List<ModelOt> list =
        res.isNotEmpty ? res.map((c) => ModelOt.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ModelApoyo>> getAsignacionesOTS(int idu) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "select * from Inv_ApoyosOT where idot=$idu and apoyotemporal in (0,-12,-10)");
    List<ModelApoyo> list =
        res.isNotEmpty ? res.map((c) => ModelApoyo.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ModelApoyo>> getAsignacionesOTStemp(int idu) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from Inv_ApoyosOT where idot=$idu");
    List<ModelApoyo> list =
        res.isNotEmpty ? res.map((c) => ModelApoyo.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ModelTipoluminaria>> gettipoluminarias() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from tbl_tipoluminaria");
    List<ModelTipoluminaria> list = res.isNotEmpty
        ? res.map((c) => ModelTipoluminaria.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<ModelPotencialuminaria>> getpotenciasluminarias() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from tbl_potenciaLuminaria");
    List<ModelPotencialuminaria> list = res.isNotEmpty
        ? res.map((c) => ModelPotencialuminaria.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<ModelEstadoluminaria>> getestadosluminarias() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from tbl_luiminariaestados");
    List<ModelEstadoluminaria> list = res.isNotEmpty
        ? res.map((c) => ModelEstadoluminaria.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<ModelValorizacionluminaria>> getvalorizacionluminarias() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from tbl_valorizacionluminaria");
    List<ModelValorizacionluminaria> list = res.isNotEmpty
        ? res.map((c) => ModelValorizacionluminaria.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> guardarAlumbrado(ModelLuminaria os) async {
    final db = await DBProvider.db.database;
    final res = await db.rawInsert(
        "INSERT Into Inv_LuminariasOT (idapoyo,tipo,tipootros,potencia,potenciaotros,estadoluminaria,lat,lon,observacion,fechaRegistro,idot) " +
            " VALUES (" +
            os.idapoyo.toString() +
            ",'" +
            os.tipo +
            "','" +
            os.tipootros +
            "','" +
            os.potencia +
            "','" +
            os.potenciaotros +
            "','" +
            os.estadoluminaria +
            "','" +
            os.lat +
            "','" +
            os.lon +
            "','" +
            os.observacion +
            "','" +
            os.fechaRegistro +
            "','" +
            os.idot.toString() +
            "')");
    return res;
  }

  Future<int> eliminarImagen(int ida, int tipo) async {
    final db = await DBProvider.db.database;
    final res = await db.rawDelete(
        "DELETE FROM Inv_LuminariasOTFotografias where idapoyo = $ida and tipo= $tipo");
    return res;
  }

  Future<int> nuevaFoto(ModelImagen os) async {
    final db = await DBProvider.db.database;
    final res = await db.rawInsert(
        "INSERT Into Inv_LuminariasOTFotografias (idapoyo,idot,foto,tipo) " +
            " VALUES ('" +
            os.idapoyo.toString() +
            "','" +
            os.idot.toString() +
            "','" +
            os.foto +
            "','" +
            os.tipo.toString() +
            "')");
    print("ID APOYO INSERTADOO: --->" + res.toString());
    return res;
  }

  Future<List<ModelLuminaria>> getluminariasapoyo(int idapoyo) async {
    final db = await DBProvider.db.database;
    final res = await db
        .rawQuery("select * from Inv_LuminariasOT where idapoyo =$idapoyo");
    List<ModelLuminaria> list = res.isNotEmpty
        ? res.map((c) => ModelLuminaria.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> eliminarluminaria(int id) async {
    final db = await DBProvider.db.database;
    final res =
        await db.rawDelete("DELETE FROM Inv_LuminariasOT where id = $id");
    return res;
  }

  Future<int> updateEstado(int ida, String estado) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "UPDATE Inv_ApoyosOT SET estado ='$estado' where idapoyo=$ida");
    return 1;
  }

  Future<int> updateEstadoEspecial(
      int ida, String estado, int apoyotemp) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "UPDATE Inv_ApoyosOT SET estado ='$estado', apoyotemporal=$apoyotemp where idapoyo=$ida");
    return 1;
  }

  Future<List<ModelTipoApoyo>> gettipoapoyo() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from tbl_tipoapoyo");
    List<ModelTipoApoyo> list = res.isNotEmpty
        ? res.map((c) => ModelTipoApoyo.fromJson(c)).toList()
        : [];
    return list;
  }

  //altura apoyo
  Future<List<ModelAlturaApoyo>> getalturaapoyo() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery("select * from tbl_alturaapoyo");
    List<ModelAlturaApoyo> list = res.isNotEmpty
        ? res.map((c) => ModelAlturaApoyo.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> guardaApoyo(ModelApoyonuevo os) async {
    final db = await DBProvider.db.database;
    final res = await db.rawInsert(
        "INSERT Into tbl_apoyosReportado (lat,lon,alturaapoyo,tipoapoyo,estado,idot) " +
            " VALUES (" +
            os.lat.toString() +
            ",'" +
            os.lon.toString() +
            "','" +
            os.alturaapoyo +
            "','" +
            os.tipoapoyo +
            "','" +
            os.estado.toString() +
            "','" +
            os.idot.toString() +
            "')");
    print("ID APOYO INSERTADOO: --->" + res.toString());
    return res;
  }

  Future<int> deleteasiganciones(int idot) async {
    final db = await DBProvider.db.database;
    final res = await db.rawDelete('DELETE FROM Inv_ApoyosOT where idot=$idot');
    return res;
  }

  Future<int> deletegeneral(int idot) async {
    final db = await DBProvider.db.database;
    final res =
        await db.rawDelete('DELETE FROM Inv_AsignacionOT where idot=$idot');
    return res;
  }

  Future<List<ModelApoyonuevo>> getapoyoreportados() async {
    final db = await DBProvider.db.database;
    final res =
        await db.rawQuery("select * from tbl_apoyosReportado where estado=0;");
    List<ModelApoyonuevo> list = res.isNotEmpty
        ? res.map((c) => ModelApoyonuevo.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> updateEstadoApoyorep(int ida, int estado) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "UPDATE tbl_apoyosReportado SET estado =$estado where id=$ida");
    return 1;
  }

  Future<int> updateEstadoApoyo(int ida) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "UPDATE Inv_ApoyosOT SET estado ='Enviada' where idapoyo=$ida");
    return 1;
  }

  Future<List<ModelApoyo>> getupdasignacionesenviar() async {
    final db = await DBProvider.db.database;
    final res = await db
        .rawQuery("select * from Inv_ApoyosOT where estado='Finalizada'");
    List<ModelApoyo> list =
        res.isNotEmpty ? res.map((c) => ModelApoyo.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ModelApoyo>> getupdasignacionesimagenes() async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "select * from Inv_ApoyosOT where estado='Enviada' and estadoimagen=0");
    List<ModelApoyo> list =
        res.isNotEmpty ? res.map((c) => ModelApoyo.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> updateEstadoApoyoImagen(int ida) async {
    final db = await DBProvider.db.database;
    final res = await db
        .rawQuery("UPDATE Inv_ApoyosOT SET estadoimagen =1 where idapoyo=$ida");
    return 1;
  }

  Future<List<ModelLuminaria>> getluminariaspendientes() async {
    final db = await DBProvider.db.database;
    final res =
        await db.rawQuery("select * from Inv_LuminariasOT where tipootros=''");
    List<ModelLuminaria> list = res.isNotEmpty
        ? res.map((c) => ModelLuminaria.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> updateluminaria(int ida) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "UPDATE Inv_LuminariasOT SET tipootros ='---' where idapoyo=$ida");
    return 1;
  }

  Future<List<ModelImagen>> listarimagenes(int idapoyo, int idot) async {
    final db = await DBProvider.db.database;
    final res = await db.rawQuery(
        "select * from Inv_LuminariasOTFotografias where idapoyo=$idapoyo and idot=$idot");
    List<ModelImagen> list =
        res.isNotEmpty ? res.map((c) => ModelImagen.fromJson(c)).toList() : [];
    return list;
  }
}
