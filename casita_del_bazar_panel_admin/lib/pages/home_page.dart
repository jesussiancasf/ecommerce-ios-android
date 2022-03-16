import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
/*

AQUI VA EL NUEVO CODIGO
*/
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;

    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Image.asset(
                  'assets/CASITA.png',
                  height: 45,
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<UsuarioHomePage>>(
          future: fetchPosthp(_usuario),
          builder: (BuildContext contetxt, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return datosUsuarioLogeado(items, _usuario, _rol);
                  });
            } else if (snapshot.hasError) {
              return Center(
                  child: Center(
                child: Text(
                  'Ha ocurrido un error en el servidor',
                  style: TextStyle(color: Colors.red),
                ),
              ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),

      /* */
    );
  }

  Widget datosUsuarioLogeado(
      UsuarioHomePage usuarioHomePage, String _usuario, String _rol) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
            child: Text(
              'BIENVENIDO A CASITA DEL BAZAR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 35),
            child: CircleAvatar(
                backgroundColor: Colors.red[200],
                radius: 130,
                backgroundImage:
                    NetworkImage(usuarioHomePage.imagen, scale: 0.2)),
          ),
          textoconPadding(
              _usuario,
              usuarioHomePage.nombre,
              usuarioHomePage.apellido,
              usuarioHomePage.email,
              usuarioHomePage.telefono,
              _rol),
        ],
      ),
    );
  }

  Widget textoconPadding(String _usuario, String _nombre, String _apellido,
      String _email, String _telefono, String _rol) {
    TextStyle estilo = TextStyle(
        fontSize: 16, color: Colors.red[400], fontWeight: FontWeight.bold);
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'USUARIO:',
                    style: estilo,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _usuario.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('NOMBRE:', style: estilo),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _nombre.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'APELLIDO:',
                    style: estilo,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _apellido.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('EMAIL:', style: estilo),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _email.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('TELEFONO:', style: estilo),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _telefono.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('ROL:', style: estilo),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _rol.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            )
          ],
        ));
  }
}
