//import 'dart:convert';
//import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/streams/loginStream.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginStream loginStream = new LoginStream();
  /*TextEditingController controlUsuario = new TextEditingController();
  TextEditingController controlPass = new TextEditingController();

  

  Future login() async {
    final response = await http.post(
        Uri.parse("http://18.228.156.121/casita/login.php"),
        body: {"usuario": controlUsuario.text, "contrasena": controlPass.text});

    var datauser = json.decode(response.body);
    print(datauser.toString());

    if (datauser.toString() == "[]") {
      print("El usuario no esta registrado");
    } else {
      String usuario = datauser[0]['ID_USUARIO'];
      String nombre = datauser[0]['NOMBRE'];
      String apellido = datauser[0]['APELLIDO'];
      String telefono = datauser[0]['TELEFONO'];
      String email = datauser[0]['EMAIL'];
      String nombreRol = datauser[0]['NOMBRE_ROL'];
      String contrasena = datauser[0]['CONTRASENA'];

      if (nombreRol == 'Administrador' || nombreRol == 'Repartidor') {
        if (controlUsuario.text == usuario && controlPass.text == contrasena) {
          Navigator.pushReplacementNamed(context, '/',
              arguments: UsuarioLogeado(
                  usuario, nombre, apellido, email, telefono, nombreRol));
        } else {
          print('Usuario o contraseña incorrectos');
        }
      } else {
        print('El usuario no es un administrador');
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 120, 50, 50),
          child: Image(image: AssetImage('assets/CASITA1.png')),
        ),
        fieldUsername(),
        fieldPassword(),
        /*ElevatedButton(
          onPressed: () {
            final snackBar = SnackBar(
              content: Text('Yay! A SnackBar!'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );

            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Text('Show SnackBar'),
        ),*/
        //crearImputs(),
        //crearImputspass(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 35, 30),
          child: TextButton(
              onPressed: () {},
              child: Text(
                'Olvidaste tu contraseña? Reestablecer',
                style: TextStyle(color: Colors.pink),
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 25, 35, 100),
          child: StreamBuilder<bool>(
            stream: loginStream.validRequest,
            builder: (context, snapshot) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[200],
                  padding: EdgeInsets.all(20),
                ),
                onPressed: !snapshot.hasData ? null : () => submitForm(context),
                child: Text('Iniciar Sesión'),
              );
            },
          ),
          /*child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.pink[200],
              padding: EdgeInsets.all(20),
            ),
            onPressed: () {
              login();
            },
            child: Text('Iniciar Sesión'),
          ),*/
        ),
      ],
    ));
  }

  Widget fieldUsername() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 10, 35, 5),
      child: StreamBuilder<String>(
        stream: loginStream.userStream,
        builder: (context, snapshot) {
          return Theme(
            data: new ThemeData(primaryColor: Colors.pink),
            child: TextField(
              autofocus: false,
              obscureText: false,
              onChanged: loginStream.changeUser,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Usuario',
                  labelText: 'Usuario',
                  border: OutlineInputBorder()),
            ),
          );
        },
      ),
    );
  }

  Widget fieldPassword() {
    bool estado = true;
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(35, 10, 35, 5),
        child: StreamBuilder<String>(
          stream: loginStream.passwordStream,
          builder: (context, snapshot) {
            return Theme(
              data: new ThemeData(primaryColor: Colors.pink),
              child: TextField(
                autofocus: false,
                obscureText: estado,
                onChanged: loginStream.changePassword,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye_sharp),
                        onPressed: () {
                          if (estado == true) {
                            setState(() {
                              estado = false;
                            });
                          } else if (estado == false) {
                            setState(() {
                              estado = true;
                            });
                          }
                        }),
                    fillColor: Colors.pink,
                    hoverColor: Colors.pink,
                    focusColor: Colors.pink,
                    prefixIcon: Icon(Icons.vpn_key),
                    hintText: 'Contraseña',
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.pink))),
              ),
            );
          },
        ),
      );
    });
  }

  void submitForm(BuildContext context) async {
    await loginStream.loginRequest(context);
  }
}
