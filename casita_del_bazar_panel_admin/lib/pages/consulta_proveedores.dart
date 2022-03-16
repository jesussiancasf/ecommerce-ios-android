import 'package:casita_del_bazar_panel_admin/clases/providerQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ConsultarProveedor extends StatefulWidget {
  ConsultarProveedor({Key key}) : super(key: key);

  @override
  _ConsultarProveedorState createState() => _ConsultarProveedorState();
}

class _ConsultarProveedorState extends State<ConsultarProveedor> {
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
              'Consultar Proveedor',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white),
        drawer: Drawer(
          child: getListHeaderItems(context, false, _usuario, _rol),
        ),
        body: CrearSearchBoxProveedor());
  }
}

class CrearSearchBoxProveedor extends StatefulWidget {
  CrearSearchBoxProveedor({Key key}) : super(key: key);

  @override
  _CrearSearchBoxProveedorState createState() =>
      _CrearSearchBoxProveedorState();
}

class _CrearSearchBoxProveedorState extends State<CrearSearchBoxProveedor> {
  int indexList;
  int id = 0;
  String nombre = "";
  String apellido = "";
  String email = "";
  String telefono = "";
  String direccion = "";
  String empresa = "";
  String imagen = "";
  String departamento = "";
  String provincia = "";
  String distrito = "";

  final estiloTexto2 = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
  final estiloTexto = TextStyle(color: Colors.pink[400], fontSize: 25);

  List listado = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProviderQuery>>(
        future: fetchPostPVQ(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              var item = snapshot.data[i];
              listado.add(item.nombre + " " + item.apellido);
            }
            return StatefulBuilder(builder: (context, setState) {
              print(listado);
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GFSearchBar(
                        noItemsFoundWidget: Text("No se encontró el proveedor"),
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
                          print(indexList);
                          id = snapshot.data[indexList].id;
                          nombre = snapshot.data[indexList].nombre;
                          apellido = snapshot.data[indexList].apellido;
                          email = snapshot.data[indexList].email;
                          telefono = snapshot.data[indexList].telefono;
                          direccion = snapshot.data[indexList].direccion;
                          empresa = snapshot.data[indexList].empresa;
                          imagen = snapshot.data[indexList].imagen;
                          departamento = snapshot.data[indexList].departamento;
                          provincia = snapshot.data[indexList].provincia;
                          distrito = snapshot.data[indexList].distrito;

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
                                crearCuadros1("#" +
                                    id.toString() +
                                    " " +
                                    nombre +
                                    " " +
                                    apellido),
                                crearCuadros2("Telefono: " + telefono),
                                crearCuadros2("Email: " + email),
                                crearCuadros2("Dirección: " + direccion),
                                crearCuadros2(departamento +
                                    " " +
                                    provincia +
                                    " " +
                                    distrito),
                                Center(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        imagen,
                                        width: 300,
                                      ),
                                      crearCuadros1(empresa),
                                      SizedBox(
                                        height: 50,
                                      )
                                    ],
                                  ),
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
