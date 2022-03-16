import 'dart:convert';
import 'dart:io';

import 'package:casita_del_bazar_panel_admin/clases/buyList.dart';
import 'package:casita_del_bazar_panel_admin/clases/productQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/productOrder.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/provider.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:casita_del_bazar_panel_admin/utils/dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Compras extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario.toString();
    String _rol = _args.rol;
    return WillPopScope(
      onWillPop: _onWillPopFunction,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Compras',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white),
        drawer: Drawer(
          child: getListHeaderItems(context, false, _usuario, _rol),
        ),
        body: FutureBuilder<List<ComprasLista>>(
            future: fetchPostBL(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length != 0
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var items = snapshot.data[index];
                          return ListarComprasItems(items);
                        })
                    : Padding(
                        padding: const EdgeInsets.all(82.0),
                        child: Center(
                            child: Text(
                          "Parece que aun no tienes compras",
                          style: TextStyle(color: Colors.black, fontSize: 25),
                          textAlign: TextAlign.center,
                        )),
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
        floatingActionButton: _agregarBotonesFlotantes(context, _rol),
      ),
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

  Widget _agregarBotonesFlotantes(BuildContext context, _rol) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            setState(() {});
          },
          child: Icon(Icons.replay_outlined),
        ),
        _rol == "Administrador"
            ? FloatingActionButton(
                heroTag: null,
                onPressed: () => _mostrarAlerta(context),
                child: Icon(Icons.add),
              )
            : Text(""),
      ],
    );
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MiDialogoCompra();
        });
  }
}

class ListarComprasItems extends StatelessWidget {
  final ComprasLista lista;
  ListarComprasItems(this.lista);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.shopping_bag_rounded,
        color: Colors.pink[400],
        size: 30,
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 10, 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Compra # " + lista.id.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(lista.fecha, style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(lista.empresa),
                  Text(
                    "S./ " + lista.monto.toString(),
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MiDialogoCompra extends StatefulWidget {
  MiDialogoCompra({Key key}) : super(key: key);

  @override
  _MiDialogoCompraState createState() => _MiDialogoCompraState();
}

class _MiDialogoCompraState extends State<MiDialogoCompra> {
  List<String> listado = [];
  List<String> listCompany = [];
  String dropdownValue = "Empresa";
  int idProveedor;
  String _fecha = 'Fecha';
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController comprobanteT = new TextEditingController();
  TextEditingController cantidadT = new TextEditingController();
  TextEditingController precioT = new TextEditingController();
  double subtotales = 0;

  String dropdownValue2 = "Tipo Comprobante";
  String dropdownValue3 = "Selecciona productos";

  List<String> listaComprobante = [
    "Boleta",
    "Boleta Electrónica",
    "Factura",
    "Factura electrónica",
    "Nota de venta"
  ];
  String idComprobante = "";
  String url =
      "https://www.detallesmasbonitaqueninguna.com/server/Portal_0015715/img/products/no_image_xxl.jpg";

  File _image;
  final picker = ImagePicker();
  Future elegirImagen() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      try {
        _image = File(pickedImage.path);
      } catch (e) {
        print("Cancelado");
      }
    });
    listado.clear();
    listCompany.clear();
  }

  @override
  Widget build(BuildContext context) {
    final datos = Provider.of<UsersProviders>(context, listen: true).datos;

    return AlertDialog(
      title: Text('Agregar Compra'),
      content: Container(
        width: double.maxFinite,
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              ////////////////////////////////////////
              ///LISTAR PROVEEDORES PARA COMPRA
              ////////////////////////////////////////
              ///
              ///
              ///
              FutureBuilder<List<ProvidersWidget>>(
                  future: fetchPostPW(),
                  builder: (BuildContext contetxt, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data.length; i++) {
                        var item = snapshot.data[i];
                        listCompany.add(item.empresa);
                      }

                      return SearchableDropdown.single(
                        items: listCompany
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: dropdownValue,
                        hint: "Elige Empresa",
                        searchHint: "Elige Empresa",
                        onChanged: (value) {
                          if (value == null) {
                            dropdownValue = "Elige Empresa";
                            idProveedor = null;
                          } else {
                            dropdownValue = value;
                            idProveedor = snapshot
                                .data[listCompany.indexOf(dropdownValue)].id;
                            print(idProveedor);
                          }
                        },
                        isExpanded: true,
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

              ///////////////////////////////////////////////////////////////
              ///DROPDOWNS DE PEDIDO (TODOS)
              ///DIRECCION, DEP,PROV,DIS, MET. PAGO, MET. ENVIO
              /////////////////////////////////////////////////////////////////
              ///
              ///

              SizedBox(height: 10),

///////////////////////////////////////////////////////////////////////////////////
              ///BUSCAR PRODUCTOS
              ///
///////////////////////////////////////////////////////////////////////////

              FutureBuilder<List<ProductQuery>>(
                  future: fetchPostPQ(),
                  builder: (BuildContext contetxt, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data.length; i++) {
                        var item = snapshot.data[i];
                        listado.add(item.id.toString() + " : " + item.nombre);
                      }

                      return SearchableDropdown.single(
                        items: listado
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: dropdownValue3,
                        hint: "Selecciona Productos",
                        searchHint: "Selecciona Productos",
                        onChanged: (value) {
                          if (value == null) {
                            dropdownValue3 = "Selecciona Productos";
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(snapshot
                                        .data[listado.indexOf(value)].nombre),
                                    content: Container(
                                      width: double.maxFinite,
                                      child: ListView(
                                        children: [
                                          Image.network(
                                              snapshot
                                                  .data[listado.indexOf(value)]
                                                  .imagen,
                                              width: 300),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            snapshot
                                                .data[listado.indexOf(value)]
                                                .descripcion,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          snapshot.data[listado.indexOf(value)]
                                                      .stock !=
                                                  0
                                              ? Text(
                                                  "Quedan " +
                                                      snapshot
                                                          .data[listado
                                                              .indexOf(value)]
                                                          .stock
                                                          .toString() +
                                                      " en Stock",
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                )
                                              : Text(
                                                  "Agotado",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15),
                                                ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          snapshot.data[listado.indexOf(value)]
                                                      .precioDescuento ==
                                                  0
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      "S./" +
                                                          (snapshot
                                                                  .data[listado
                                                                      .indexOf(
                                                                          value)]
                                                                  .precio)
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 28,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "S./" +
                                                            (snapshot
                                                                    .data[listado
                                                                        .indexOf(
                                                                            value)]
                                                                    .precioDescuento)
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 28,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "S./" +
                                                            (snapshot
                                                                    .data[listado
                                                                        .indexOf(
                                                                            value)]
                                                                    .precio)
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          _crearInput(
                                              "Cantidad",
                                              Icon(Icons.plus_one_sharp),
                                              cantidadT,
                                              TextInputType.number),
                                          _crearInput(
                                              "Precio",
                                              Icon(Icons.plus_one_sharp),
                                              precioT,
                                              TextInputType.number),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<UsersProviders>(context,
                                                      listen: false)
                                                  .elemnt =
                                              (OrdenProductos(
                                                  idProducto: snapshot
                                                      .data[listado
                                                          .indexOf(value)]
                                                      .id,
                                                  nombre: snapshot
                                                      .data[listado
                                                          .indexOf(value)]
                                                      .nombre,
                                                  costo: double.parse(
                                                      precioT.text),
                                                  cantidad:
                                                      int.parse(cantidadT.text),
                                                  image: snapshot
                                                      .data[listado
                                                          .indexOf(value)]
                                                      .imagen));

                                          subtotales = subtotales +
                                              int.parse(cantidadT.text) *
                                                  double.parse(precioT.text);
                                          Provider.of<UsersProviders>(context,
                                                  listen: false)
                                              .subtotal = subtotales;
                                          listado.clear();
                                          precioT.text = "";
                                          cantidadT.text = "";
                                          listado.clear();

                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Agregar"),
                                      )
                                    ],
                                  );
                                });
                          }

                          //selectedValue = value;
                        },
                        isExpanded: true,
                      );
                    } else if (snapshot.hasError) {
                      return AlertDialog(
                          title: Text(
                        'Error:\n${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),

              SizedBox(height: 30),

/////////////////////////////////////////////////////////////////////////////////////////
              ///RESUMEN DEL PEDIDO
              ///
              ///
              Text(
                "RESUMEN DE LA COMPRA",
              ),
              SizedBox(height: 15),

              datos.length != 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: datos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Image.network(
                                    datos[index].image,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(datos[index].nombre),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                Expanded(
                                    flex: 3,
                                    child:
                                        Text(datos[index].cantidad.toString())),
                                Expanded(
                                    flex: 3,
                                    child:
                                        Text((datos[index].costo).toString())),
                                Expanded(
                                    flex: 3,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle_sharp,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        subtotales = subtotales -
                                            (datos[index].costo *
                                                datos[index].cantidad);
                                        Provider.of<UsersProviders>(context,
                                                listen: false)
                                            .subtotal = subtotales;
                                        Provider.of<UsersProviders>(context,
                                                listen: false)
                                            .delete = index;
                                      },
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            )
                          ],
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Aún no hay productos"),
                    ),

//////////////////////////////////////////////////////////////////////////////////////////////////
              ///TOTALES Y SUBTOTALES
              ///
              ///
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text("Total Pagado :"),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("S./ " +
                            (Provider.of<UsersProviders>(context, listen: false)
                                    .subtotal)
                                .toString()),
                        flex: 1,
                      )
                    ],
                  ),
                ],
              ),

              SizedBox(height: 40),
              _crearInput("# Comprobante", Icon(Icons.text_snippet_rounded),
                  comprobanteT, TextInputType.text),
              _crearDropDownMenu(listaComprobante),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _image == null
                      ? Image(image: NetworkImage(url))
                      : Image.file(_image),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(7, 15, 0, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          elegirImagen();
                        },
                        child: Text('Cargar imagen de producto'),
                      )),
                ],
              ),
              SizedBox(height: 20),

              _crearFecha(context, _fecha),
            ],
          )
        ]),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              //////////////////////////////////////////////
              ///CAMBIAR A 0 TODOS LOS PROVIDERS
              ///
              ///
              ///
              Navigator.of(context).pop();
              Provider.of<UsersProviders>(context, listen: false).deleteAll =
                  true;
              Provider.of<UsersProviders>(context, listen: false).subtotal =
                  0.0;
              //////////////////////////////////////////////
              ///
              ///
              ///
              ///
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () {
              print(Provider.of<UsersProviders>(context, listen: false).datos);
              funcionAgregar(
                  Provider.of<UsersProviders>(context, listen: false).datos,
                  context);
            },
            child: Text('Guardar'))
      ],
    );
  }

  Widget _crearInput(String campo, Icon icono, TextEditingController controller,
      TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        validator: (value) {
          if (value.isEmpty) {
            return 'Escribe el precio de compra';
          }
          return null;
        },
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: '$campo',
          icon: icono,
          labelText: '$campo',
        ),
      ),
    );
  }

  Widget _crearFecha(BuildContext context, String fecha) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: TextField(
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: fecha,
          labelText: fecha,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          listCompany.clear();

          _selectDate(context);
        },
      ),
    );
  }

  //////////////////////////////////////////////////////////////////

  _selectDate(BuildContext contexto) async {
    DateTime picked = await showDatePicker(
      context: contexto,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),
      currentDate: DateTime.now(),

      //locale: Locale('es', 'ES')
    );

    if (picked != null) {
      listCompany.clear();
      listado.clear();

      _fecha = picked.toString();
      _inputFieldDateController.text = _fecha;
    } else {
      listCompany.clear();
      listado.clear();
    }
  }

  Widget _crearDropDownMenu(List<String> lista) {
    return DropdownWidget(
      items: lista.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                color: Colors.black87,
              )),
        );
      }).toList(),
      hintTextValue: dropdownValue2,
      onChanged: (value) {
        dropdownValue2 = value;

        switch (dropdownValue2) {
          case "Boleta":
            idComprobante = "bol";
            break;
          case "Boleta Electrónica":
            idComprobante = "bolE";
            break;

          case "Factura":
            idComprobante = "fac";
            break;

          case "Factura electrónica":
            idComprobante = "facE";
            break;
          case "Nota de venta":
            idComprobante = "not";
            break;
        }
        print(idComprobante);
      },
    );
  }

  Future addBuy(BuildContext context) async {
    final uri =
        Uri.parse("http://18.228.156.121/casita/insertar/buyOrder/addBuy.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['monto'] =
        Provider.of<UsersProviders>(context, listen: false).subtotal.toString();
    request.fields['fecha'] = _fecha;
    request.fields['comprobante'] = comprobanteT.text;
    request.fields['tipoComprobante'] = idComprobante;
    request.fields['idProveedor'] = idProveedor.toString();

    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.body.toString() == '"ingresado"') {
      print("Ingresado");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  ),
                  Text("   Ha ocurrido un error " +
                      response.statusCode.toString())
                ],
              ),
              actions: [
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

  Future addOrderBuy(String idProducto, String cantidad, String pCompra) async {
    final response2 = await http.post(
        Uri.parse(
            "http://18.228.156.121/casita/insertar/buyOrder/addBuyDetail.php"),
        body: {
          "idProducto": idProducto,
          "cantidad": cantidad,
          "pCompra": pCompra,
          "nComprobante": comprobanteT.text,
          "idProveedor": idProveedor.toString(),
        });

    var datauser = json.decode(response2.body);
    print(datauser + "datauser");
    print(response2.body + " response.body");
    if (response2.body == '"Ingresado"') {
      print("ingresoooooo");
    }
    if (response2.body == '"Error"') {
      print("un error");
    }
  }

  Future funcionAgregar(
      List<OrdenProductos> datos, BuildContext context) async {
    await addBuy(context);
    for (var item in datos) {
      await addOrderBuy(item.idProducto.toString(), item.cantidad.toString(),
          item.costo.toString());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 30,
                ),
                Text("   Compra registrada"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("Aceptar"),
              )
            ],
          );
        });
    Provider.of<UsersProviders>(context, listen: false).deleteAll = true;
    Provider.of<UsersProviders>(context, listen: false).subtotal = 0.0;
  }
}
