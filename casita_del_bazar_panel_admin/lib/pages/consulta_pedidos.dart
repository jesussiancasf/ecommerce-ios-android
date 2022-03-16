import 'dart:convert';

import 'package:casita_del_bazar_panel_admin/clases/orderQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/productOrderDetail.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

class ConsultaPedidos extends StatefulWidget {
  @override
  _ConsultaPedidosState createState() => _ConsultaPedidosState();
}

class _ConsultaPedidosState extends State<ConsultaPedidos> {
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
                'Consulta pedidos',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              backgroundColor: Colors.white),
          drawer: Drawer(
            child: getListHeaderItems(context, false, _usuario, _rol),
          ),
          body: CrearSearchBoxOrder()),
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

class CrearSearchBoxOrder extends StatefulWidget {
  @override
  _CrearSearchBoxOrderState createState() => _CrearSearchBoxOrderState();
}

class _CrearSearchBoxOrderState extends State<CrearSearchBoxOrder> {
  List<String> listado = [];
  int indexList;
  int id = 0;
  String fecha = "";
  String metodoPago = "";
  String metodoEnvio = "";
  String estadoPedido = "";
  String nombre = "";
  String apellido = "";
  double total = 0;
  String direccion = "";
  String departamento = "";
  String provincia = "";
  String distrito = "";
  String telefono = "";
  String email = "";
  double costoEnvio = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderQuery>>(
        future: fetchPostOQS(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              var item = snapshot.data[i];
              listado.add("#" +
                  item.id.toString() +
                  " : " +
                  item.nombre +
                  " " +
                  item.apellido);
            }
            return StatefulBuilder(builder: (context, setState) {
              print(listado);
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GFSearchBar(
                        noItemsFoundWidget: Text("No se encontraron pedidos"),
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
                          metodoPago = snapshot.data[indexList].metodoPago;
                          metodoEnvio = snapshot.data[indexList].metodoEnvio;
                          estadoPedido = snapshot.data[indexList].estadoPedido;
                          fecha = snapshot.data[indexList].fecha;
                          nombre = snapshot.data[indexList].nombre;
                          apellido = snapshot.data[indexList].apellido;
                          total = snapshot.data[indexList].total;
                          direccion = snapshot.data[indexList].direccion;
                          departamento = snapshot.data[indexList].departamento;
                          provincia = snapshot.data[indexList].provincia;
                          distrito = snapshot.data[indexList].distrito;
                          telefono = snapshot.data[indexList].telefono;
                          email = snapshot.data[indexList].email;
                          costoEnvio = snapshot.data[indexList].costoEnvio;
                          if (item == null) {
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                      nombre != ""
                          ? Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 40, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  tituloWidget("NÚMERO DE PEDIDO:",
                                      id.toString(), Colors.red[400]),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  crearRows("Fecha", fecha),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  tituloWidget(
                                      "DATOS DE USUARIO", "", Colors.black),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  crearRows("Nombre", nombre),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("Apellido", apellido),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("Telefono", telefono),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("Email", email),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  tituloWidget(
                                      "DATOS DE ENVIO", "", Colors.black),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  crearRows("DIRECCIÓN", direccion),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("DEPARTAMENTO", departamento),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("PROVINCIA", provincia),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("DISTRITO", distrito),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  tituloWidget(
                                      "PAGO Y ENVÍO", "", Colors.black),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  crearRows("METODO DE PAGO", metodoPago),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("METODO DE ENVÍO", metodoEnvio),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows("PRECIO ENVIO",
                                      "S./" + costoEnvio.toString()),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  crearRows(
                                      "TOTAL PAGADO", "S./" + total.toString()),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.red[400], // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              _mostrarAlerta(context);
                                            },
                                            child: Text("Detalle Pedido")),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.red[400], // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              hayPromo();
                                            },
                                            child: Text("Promos usadas")),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
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
    List<DetallePedidoQuery> lista = [];
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
                      FutureBuilder<List<DetallePedidoQuery>>(
                          future: fetchPostDPQL(id.toString()),
                          builder: (BuildContext contetxt, snapshot) {
                            if (snapshot.hasData) {
                              for (var item in snapshot.data) {
                                lista.add(DetallePedidoQuery(
                                    nombre: item.nombre,
                                    imagen: item.imagen,
                                    cantidad: item.cantidad,
                                    precio: item.precio,
                                    precioDescuento: item.precioDescuento));
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
                                                  "Precio",
                                                  style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                lista[index].precioDescuento ==
                                                        0
                                                    ? Text(
                                                        lista[index]
                                                            .precio
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14))
                                                    : Text(
                                                        lista[index]
                                                            .precioDescuento
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

  Future hayPromo() async {
    final response = await http.post(
        Uri.parse("http://18.228.156.121/casita/listar/couponOrderQuery.php"),
        body: {"idPedido": id.toString()});

    var datauser = json.decode(response.body);
    print(datauser.toString());

    if (datauser.toString() == "[]") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('No se usaron cupones'),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(''),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Aceptar"),
                )
              ],
            );
          });
    } else {
      String cupon = datauser[0]['CODIGO_CUPON'];
      double importe = double.parse(datauser[0]['IMPORTE']);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Cupón " + cupon),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Cupon de descuento de:"),
                  Text(importe.toString() + " soles"),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Aceptar"),
                )
              ],
            );
          });
    }
  }
}
