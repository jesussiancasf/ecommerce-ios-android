import 'dart:convert';

import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/model/User.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class LoginStream {
  final _userControll = BehaviorSubject<String>();
  final _passControll = BehaviorSubject<String>();

  Stream<String> get userStream => _userControll.stream;
  Stream<String> get passwordStream => _passControll.stream;

  Function(String) get changeUser => _userControll.sink.add;
  Function(String) get changePassword => _passControll.sink.add;

  String get usuario => _userControll.value;
  String get password => _passControll.value;

  Stream<bool> get validRequest =>
      Rx.combineLatest2(userStream, passwordStream, (a, b) => true);

  Future<dynamic> loginRequest(BuildContext context) async {
    dynamic serverResp;
    User user = new User();
    user.usuario = usuario;
    user.contrasena = password;
    final response = await http.post(
        Uri.parse("http://18.228.156.121/casita/login.php"),
        body: {"usuario": user.usuario, "contrasena": user.contrasena});
    var datauser = json.decode(response.body);

    if (datauser.length > 0) {
      if (datauser[0]['NOMBRE_ROL'] == 'Administrador' ||
          datauser[0]['NOMBRE_ROL'] == 'Repartidor') {
        UsuarioLogeado usuarioLogeado = new UsuarioLogeado(
            datauser[0]['ID_USUARIO'], datauser[0]['NOMBRE_ROL']);

        final snackBar = SnackBar(
          content: Text('Correcto'),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacementNamed(context, '/', arguments: usuarioLogeado);
      } else {
        final snackBar = SnackBar(
          content: Text('El usuario no tiene permisos necesarios'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: Text('Usuario o contraseña incorrectos'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return serverResp;
  }

  void dispose() {
    this._userControll?.close();
    this._passControll?.close();
  }
}
