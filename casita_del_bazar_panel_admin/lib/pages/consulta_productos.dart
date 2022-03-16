import 'package:casita_del_bazar_panel_admin/clases/productQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ConsultarProductos extends StatefulWidget {
  @override
  _ConsultarProductosState createState() => _ConsultarProductosState();
}

class _ConsultarProductosState extends State<ConsultarProductos> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Consultar producto',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white),
        drawer: Drawer(
          child: getListHeaderItems(context, false, _usuario, _rol),
        ),
        body: CrearSearchBox());
  }
}

class CrearSearchBox extends StatefulWidget {
  CrearSearchBox({Key key}) : super(key: key);

  @override
  _CrearSearchBoxState createState() => _CrearSearchBoxState();
}

class _CrearSearchBoxState extends State<CrearSearchBox> {
  int indexList;
  int id = 0;
  String nombre = "";
  String descripcion = "";
  double peso = 0;
  String imagen = "";
  double precio = 0;
  double precioDescuento = 0;
  String categoria = "";
  int stock = 0;

  final estiloTexto2 = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
  final estiloTexto = TextStyle(color: Colors.pink[400], fontSize: 25);

  List listado = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductQuery>>(
        future: fetchPostPQ(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              var item = snapshot.data[i];
              listado.add(item.nombre);
            }
            return StatefulBuilder(builder: (context, setState) {
              print(listado);
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GFSearchBar(
                        noItemsFoundWidget:
                            Text("No se encontraron resultados"),
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
                          descripcion = snapshot.data[indexList].descripcion;
                          peso = snapshot.data[indexList].peso;
                          imagen = snapshot.data[indexList].imagen;
                          precio = snapshot.data[indexList].precio;
                          precioDescuento =
                              snapshot.data[indexList].precioDescuento;
                          categoria = snapshot.data[indexList].categoria;
                          stock = snapshot.data[indexList].stock;

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
                                    "#" + id.toString() + "   " + nombre),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 20, 10),
                                  child: precioDescuento != 0
                                      ? Row(
                                          children: [
                                            Text(
                                              "S./" + (precio).toString(),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            SizedBox(
                                              width: 28,
                                            ),
                                            Text(
                                              "S./" +
                                                  (precioDescuento).toString(),
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 28,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              "S./" + (precio).toString(),
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Image.network(
                                    imagen,
                                    width: 300,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                crearCuadros2(descripcion),
                                Row(
                                  children: [
                                    Expanded(
                                      child: crearCuadros2(
                                          "Peso: " + peso.toString() + " Kg"),
                                    ),
                                    Expanded(
                                      child: crearCuadros2("Stock: " +
                                          stock.toString() +
                                          " unidades"),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    Expanded(
                                        child: crearCuadros1("" + categoria)),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                )
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
