import 'package:casita_del_bazar_panel_admin/clases/userQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ConsultaUsuario extends StatefulWidget {
  @override
  _ConsultaUsuarioState createState() => _ConsultaUsuarioState();
}

class _ConsultaUsuarioState extends State<ConsultaUsuario> {
  final estiloTexto2 = TextStyle(color: Colors.black, fontSize: 18);
  final estiloTexto = TextStyle(color: Colors.blue, fontSize: 25);
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Consultar Usuario',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: CrearSearchBoxUser(),
    );
  }
}

class CrearSearchBoxUser extends StatefulWidget {
  CrearSearchBoxUser({Key key}) : super(key: key);

  @override
  _CrearSearchBoxUserState createState() => _CrearSearchBoxUserState();
}

class _CrearSearchBoxUserState extends State<CrearSearchBoxUser> {
  int indexList;
  String usuario = "";
  String nombre = "";
  String apellido = "";
  String telefono = "";
  String email = "";
  String direccion = "";
  String departamento = "";
  String provincia = "";
  String distrito = "";
  String rol = "";
  String imagen = "";

  final estiloTexto2 = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
  final estiloTexto = TextStyle(color: Colors.pink[400], fontSize: 25);

  List listado = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserQuery>>(
        future: fetchPostUQ(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              var item = snapshot.data[i];
              listado.add(item.nombre.toUpperCase() +
                  " " +
                  item.apellido.toUpperCase());
            }
            return StatefulBuilder(builder: (context, setState) {
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GFSearchBar(
                        noItemsFoundWidget: Text("No se encontraron usuarios"),
                        hideSearchBoxWhenItemSelected: false,
                        searchList: listado,
                        searchQueryBuilder: (query, list) {
                          return list
                              .where((item) => item
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        },
                        overlaySearchListItemBuilder: (item) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        },
                        onItemSelected: (item) {
                          indexList = listado.indexOf(item);

                          usuario = snapshot.data[indexList].usuario;
                          nombre = snapshot.data[indexList].nombre;
                          apellido = snapshot.data[indexList].apellido;
                          telefono = snapshot.data[indexList].telefono;
                          email = snapshot.data[indexList].email;
                          direccion = snapshot.data[indexList].direccion;
                          departamento = snapshot.data[indexList].departamento;
                          provincia = snapshot.data[indexList].provincia;
                          distrito = snapshot.data[indexList].distrito;
                          rol = snapshot.data[indexList].rol;
                          imagen = snapshot.data[indexList].imagen;

                          if (item == null) {
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                      nombre != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                crearCuadros1(
                                    "ID : " + usuario.toString().toUpperCase()),
                                crearCuadros2(nombre.toUpperCase() +
                                    " " +
                                    apellido.toUpperCase()),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Image.network(imagen, width: 300),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                crearCuadros2("Telefono: " + telefono),
                                crearCuadros2("Email: " + email),
                                crearCuadros2("Dirección " + direccion),
                                crearCuadros2(departamento +
                                    "-" +
                                    provincia +
                                    "-" +
                                    distrito),
                                Row(
                                  children: [crearCuadros1("" + rol)],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            )
                          : Text("")
                    ],
                  )
                ],
              );
            });
          } else if (snapshot.hasError) {
            return AlertDialog(
                title: Text(
              'Error:\n${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget crearCuadros1(String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 20, 10),
      child: Text(
        texto,
        style: estiloTexto,
      ),
    );
  }

  Widget crearCuadros2(String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 20, 10),
      child: Text(
        texto,
        style: estiloTexto2,
      ),
    );
  }
}
