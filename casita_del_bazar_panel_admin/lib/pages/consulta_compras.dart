import 'dart:convert';

import 'package:casita_del_bazar_panel_admin/clases/buyQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/rGuideBuyQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/productOrderBuyDetail.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

class ConsultarCompras extends StatefulWidget {
  ConsultarCompras({Key key}) : super(key: key);

  @override
  _ConsultarComprasState createState() => _ConsultarComprasState();
}

class _ConsultarComprasState extends State<ConsultarCompras> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return WillPopScope(
      onWillPop: _onWillPopFunction,
      child: Scaffold(
          appBar: AppBar(
              title: Text(
                'Consultar Compras',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              backgroundColor: Colors.white),
          drawer: Drawer(
            child: getListHeaderItems(context, false, _usuario, _rol),
          ),
          body: CrearSearchBoxCompras()),
    );
  }

  Future<bool> _onWillPopFunction() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Salir de la aplicación"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "No",
                      style: TextStyle(
                          color: Colors.red[400], fontWeight: FontWeight.bold),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Sí",
                      style: TextStyle(
                          color: Colors.red[400], fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }
}

class CrearSearchBoxCompras extends StatefulWidget {
  @override
  _CrearSearchBoxComprasState createState() => _CrearSearchBoxComprasState();
}

class _CrearSearchBoxComprasState extends State<CrearSearchBoxCompras> {
  List<String> listado = [];
  int indexList;
  String apellido = "";
  String telefono = "";
  String email = "";
  String empresa = "";
  int id = 0;
  String fecha = "";
  double total = 0;
  String comprobante = "";
  String tipoComprobante = "";
  String imagen = "";
  String nombre = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BuyQuery>>(
        future: fetchPostBQS(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              var item = snapshot.data[i];
              listado.add("#" +
                  item.id.toString() +
                  "  :  " +
                  item.empresa +
                  "  :  " +
                  item.fecha);
            }
            return StatefulBuilder(builder: (context, setState) {
              print(listado);
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GFSearchBar(
                        noItemsFoundWidget: Text("No se encontraron compras"),
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
                          nombre = snapshot.data[indexList].nombre;
                          apellido = snapshot.data[indexList].apellido;
                          telefono = snapshot.data[indexList].telefono;
                          email = snapshot.data[indexList].email;
                          empresa = snapshot.data[indexList].empresa;
                          id = snapshot.data[indexList].id;
                          fecha = snapshot.data[indexList].fecha;
                          total = snapshot.data[indexList].total;
                          comprobante = snapshot.data[indexList].comprobante;
                          tipoComprobante =
                              snapshot.data[indexList].tipoComprobante;
                          imagen = snapshot.data[indexList].imagen;

                          if (item == null) {
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                      nombre != ""
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 40, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      tituloWidget("COMPRA NUMERO:",
                                          id.toString(), Colors.red[400]),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      tituloWidget("DATOS DE PROVEEDOR", "",
                                          Colors.black),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      crearRows("NOMBRE", nombre),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows("APELLIDO", apellido),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows("TELEFONO", telefono),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows("EMAIL", email),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows("EMPRESA", empresa),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      tituloWidget("DATOS DE LA COMPRA", "",
                                          Colors.black),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      crearRows("FECHA", fecha),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows(
                                          "MONTO", total.toString() + " soles"),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      tituloWidget("COMPROBANTE DE PAGO", "",
                                          Colors.black),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      crearRows("NÚMERO COMPROBANTE",
                                          comprobante.toUpperCase()),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows("TIPO DE COMPROBANTE",
                                          tipoComprobante),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      crearRows("FOTO COMPROBANTE", ""),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image.network(
                                        imagen,
                                        width: double.infinity,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .red[400], // background
                                                  onPrimary: Colors
                                                      .white, // foreground
                                                ),
                                                onPressed: () {
                                                  _mostrarAlerta2(context);
                                                },
                                                child: Text("Detalle Compra")),
                                          ),
                                          Expanded(
                                            child: SizedBox(),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .red[400], // background
                                                  onPrimary: Colors
                                                      .white, // foreground
                                                ),
                                                onPressed: () {
                                                  _mostrarAlerta(context);
                                                },
                                                child:
                                                    Text("Guia de Remisión")),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
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

  Widget crearRows(String nombre, String campo) {
    TextStyle estilo = TextStyle(
        fontSize: 16, color: Colors.red[400], fontWeight: FontWeight.bold);
    TextStyle estilo2 = TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            nombre + ':',
            style: estilo,
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            campo,
            style: estilo2,
          ),
        ),
      ],
    );
  }

  Widget tituloWidget(String nombre, String campo, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            nombre,
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            campo,
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _mostrarAlerta(BuildContext context) {
    List<GuiasRemisionList> lista = [];
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Guias de remisión'),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FutureBuilder<List<GuiasRemisionList>>(
                          future: fetchPostGRQL(id.toString()),
                          builder: (BuildContext contetxt, snapshot) {
                            if (snapshot.hasData) {
                              for (var item in snapshot.data) {
                                lista.add(GuiasRemisionList(
                                    numero: item.numero,
                                    descripcion: item.descripcion,
                                    fecha: item.fecha,
                                    imagen: item.imagen));
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: lista.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        lista[index].imagen,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "N° de Guia",
                                                  style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                    lista[index]
                                                        .numero
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Fecha",
                                                  style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                    lista[index]
                                                        .fecha
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Detalles",
                                        style: TextStyle(
                                            color: Colors.red[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Text(lista[index].descripcion.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                'Error:\n${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar')),
            ],
          );
        });
  }

  void _mostrarAlerta2(BuildContext context) {
    List<DetalleCompraQuery> lista = [];
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Detalle del pedido'),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FutureBuilder<List<DetalleCompraQuery>>(
                          future: fetchPostDCQL(id.toString()),
                          builder: (BuildContext contetxt, snapshot) {
                            if (snapshot.hasData) {
                              for (var item in snapshot.data) {
                                lista.add(DetalleCompraQuery(
                                  nombre: item.nombre,
                                  imagen: item.imagen,
                                  cantidad: item.cantidad,
                                  precio: item.precio,
                                ));
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: lista.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Image.network(
                                              lista[index].imagen,
                                              width: 30,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nombre",
                                                  style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(lista[index].nombre,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Cantidad",
                                                  style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                    lista[index]
                                                        .cantidad
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Precio compra",
                                                  style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                    lista[index]
                                                        .precio
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14)),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      )
                                    ],
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                'Error:\n${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar')),
            ],
          );
        });
  }
}
