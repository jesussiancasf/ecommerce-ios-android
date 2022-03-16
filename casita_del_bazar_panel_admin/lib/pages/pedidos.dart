import 'dart:convert';
import 'package:casita_del_bazar_panel_admin/clases/pedidosList.dart';
import 'package:casita_del_bazar_panel_admin/clases/productQuery.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/productOrder.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/shippingMethod.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/users.dart';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/departamento.dart';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/distrito.dart';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/provincia.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/streams/locationsStream.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:casita_del_bazar_panel_admin/utils/dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario.toString();
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Pedidos',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<PedidosList>>(
          future: fetchPostPED(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return ListarPedidosItems(items);
                  });
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
    );
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
          return MiDialogoPedido();
        });
  }
}

class MiDialogoPedido extends StatefulWidget {
  @override
  _MiDialogoPedidoState createState() => _MiDialogoPedidoState();
}

class _MiDialogoPedidoState extends State<MiDialogoPedido> {
////////////////////////////////////////////////////////////////
//VARIABLES GLOBALES DE PEDIDOS
  ////////////////////////////////////////////////////////////////
  ///
  ///
  TextEditingController fechaT = new TextEditingController();
  TextEditingController direccionT = new TextEditingController();
  TextEditingController cuponT = new TextEditingController();
  TextEditingController cantidadT = new TextEditingController();

  String usuario = ""; //ID DEL USUARIO PARA LA TABLA PEDIDOS
  String idDep = "";
  String idProv = "";
  String idDis = ""; //ID DISRTITO PARA LA TABLA PEDIDOS
  int mPago; //METODO DE PAGO PARA LA TABLA PEDIDOS
  int mEnvio; //METODO DE ENVIO PARA LA TABLA PEDIDOS

  ///////////////////////////////////////////////
  double precioEnvio = 0;
  String nombreEnvio = "";
  /////////////////////////////////////////
  int estado = 1;

  ////////////////////////////////////////////
  //List<OrdenProductos> productos = []; //PRODUCTOS PARA DETALLE PEDIDO
  List<String> listado = [];
  List<String> mEnvios = [];
  int cantidad;

  ///////////
  String idCupon = ""; //ID CUPON PARA LA TABLA CUPON_PEDIDO
  double precioCupon = 0;
  String fechaCupon = "";

  ///
  ///

  ///////////////////////////////////////////////////////////////
  List<String> listUSers = [];
  String dropdownValue = "Elige usuario";
  String dropdownValue1 = "Departamento";
  String dropdownValue2 = "Provincia";
  String dropdownValue3 = "Distrito";
  String dropdownValue4 = "Método de pago";
  String dropdownValue5 = "Método de envío";
  String dropdownValue6 = "Selecciona productos";

/////////////////////////////////////////////////////////////////////////

  LocationStream bloc = new LocationStream();
  List<String> mPagos = [
    "Contra Entrega",
    "Transferencia Interbancaria",
    "Tarjeta Crédito/Débito",
    "PayPal"
  ];
  double subtotales = 0;

///////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final datos = Provider.of<UsersProviders>(context, listen: true).datos;

    return AlertDialog(
      title: Text('Agregar pedido'),
      content: Container(
        width: double.maxFinite,
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              ////////////////////////////////////////
              ///LISTAR USUARIOS PARA PEDIDO
              ////////////////////////////////////////
              ///
              ///
              ///
              FutureBuilder<List<UsuariosWidget>>(
                  future: fetchPostUWL(),
                  builder: (BuildContext contetxt, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data.length; i++) {
                        var item = snapshot.data[i];
                        listUSers.add(item.nombre + " " + item.apellido);
                      }

                      return SearchableDropdown.single(
                        items: listUSers
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: dropdownValue,
                        hint: "Elige usuario",
                        searchHint: "Elige usuario",
                        onChanged: (value) {
                          if (value == null) {
                            dropdownValue = "Elige usuario";
                            usuario = "";
                          } else {
                            dropdownValue = value;
                            usuario = snapshot
                                .data[listUSers.indexOf(dropdownValue)].id;
                            print(usuario);
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
              _crearInput("Dirección", Icon(Icons.home), direccionT),
              _crearDropDownAnidado(context),
              _crearDropDownMenu(mPagos),
              SizedBox(height: 10),

              _crearDropDownEnvio(context),

              //
              //
              //
              //
              //
              //
              //

              SizedBox(height: 20),

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
                        value: dropdownValue6,
                        hint: "Selecciona Productos",
                        searchHint: "Selecciona Productos",
                        onChanged: (value) {
                          if (value == null) {
                            dropdownValue6 = "Selecciona Productos";
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
                                          snapshot.data[listado.indexOf(value)]
                                                      .stock !=
                                                  0
                                              ? _crearInput(
                                                  "Cantidad",
                                                  Icon(Icons.plus_one_sharp),
                                                  cantidadT)
                                              : Text(""),
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
                                      snapshot.data[listado.indexOf(value)]
                                                  .stock !=
                                              0
                                          ? TextButton(
                                              onPressed: () {
                                                if (snapshot
                                                        .data[listado
                                                            .indexOf(value)]
                                                        .stock <
                                                    int.parse(cantidadT.text)) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.cancel,
                                                                color:
                                                                    Colors.red,
                                                                size: 30,
                                                              ),
                                                              Text(
                                                                  "   Cantidad incorrecta")
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  "Aceptar"),
                                                            )
                                                          ],
                                                        );
                                                      });

                                                  /*
                                                          
                                                          
                                                          
                                                          */
                                                } else {
                                                  Provider.of<UsersProviders>(context, listen: false).elemnt = (OrdenProductos(
                                                      idProducto: snapshot
                                                          .data[listado.indexOf(
                                                              value)]
                                                          .id,
                                                      nombre: snapshot
                                                          .data[listado
                                                              .indexOf(value)]
                                                          .nombre,
                                                      costo: snapshot.data[listado.indexOf(value)].precioDescuento ==
                                                              0
                                                          ? snapshot
                                                              .data[listado
                                                                  .indexOf(
                                                                      value)]
                                                              .precio
                                                          : snapshot
                                                              .data[listado.indexOf(value)]
                                                              .precioDescuento,
                                                      cantidad: int.parse(cantidadT.text),
                                                      image: snapshot.data[listado.indexOf(value)].imagen));

                                                  subtotales = subtotales +
                                                      (snapshot
                                                                      .data[listado
                                                                          .indexOf(
                                                                              value)]
                                                                      .precioDescuento ==
                                                                  0
                                                              ? snapshot
                                                                  .data[listado
                                                                      .indexOf(
                                                                          value)]
                                                                  .precio
                                                              : snapshot
                                                                  .data[listado
                                                                      .indexOf(
                                                                          value)]
                                                                  .precioDescuento) *
                                                          int.parse(
                                                              cantidadT.text);

                                                  Provider.of<UsersProviders>(
                                                          context,
                                                          listen: false)
                                                      .subtotal = subtotales;
                                                  mEnvios.clear();
                                                  listado.clear();

                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Text("Agregar"),
                                            )
                                          : Text("")
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
                "RESUMEN DEL PEDIDO",
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
                                    child: Text((datos[index].costo *
                                            datos[index].cantidad)
                                        .toString())),
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
                  : Text("Aún no hay productos"),

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
                        child: Text("Subtotal :"),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text("Envío :"),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("S./ " +
                            (Provider.of<UsersProviders>(context, listen: false)
                                    .envio)
                                .toString()),
                        flex: 1,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Cupón :"),
                        flex: 2,
                      ),
                      Expanded(
                        child:
                            Provider.of<UsersProviders>(context, listen: false)
                                        .cupon !=
                                    0
                                ? Text("S./ " +
                                    (Provider.of<UsersProviders>(context,
                                                listen: false)
                                            .cupon)
                                        .toString())
                                : Text("---"),
                        flex: 1,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Total a Pagar :"),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("S./ " +
                            (Provider.of<UsersProviders>(context, listen: false)
                                    .total)
                                .toString()),
                        flex: 1,
                      )
                    ],
                  )
                ],
              ),
              //////////////////////////////////////////////////////////////////////
              ///CUPONES
              ///
              ///////////////////////////////////////////////////////////////////////
              ///
              ///
              ///
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: _crearInput("Ingresa tu cupón",
                          Icon(Icons.confirmation_num_sharp), cuponT)),
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () {
                            cuponExiste();
                          },
                          child: Icon(Icons.search)))
                ],
              ),
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
              Provider.of<UsersProviders>(context, listen: false).cupon = 0.0;
              Provider.of<UsersProviders>(context, listen: false).envio = 0.0;
              //////////////////////////////////////////////
              ///
              ///
              ///
              ///
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () {
              addOrder();
              for (var item
                  in Provider.of<UsersProviders>(context, listen: false)
                      .datos) {
                addOrderDetail(
                    item.idProducto.toString(), item.cantidad.toString());
              }
              if (idCupon != "") {
                addCoupon();
              } else {}

              Provider.of<UsersProviders>(context, listen: false).deleteAll =
                  true;
              Provider.of<UsersProviders>(context, listen: false).deleteAll =
                  true;
              Provider.of<UsersProviders>(context, listen: false).subtotal =
                  0.0;
              Provider.of<UsersProviders>(context, listen: false).cupon = 0.0;
              Provider.of<UsersProviders>(context, listen: false).envio = 0.0;

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
                          Text("   Pedido registrado"),
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
            },
            child: Text('Guardar'))
      ],
    );
  }

  Widget _crearInput(
      String campo, Icon icono, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: TextField(
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          hintText: '$campo',
          icon: icono,
          labelText: '$campo',
        ),
      ),
    );
  }

  Widget _crearDropDownAnidado(BuildContext context) {
    List<String> departamento = [];

    ////////////////////////////////////////////////
    return Column(
      children: [
        FutureBuilder<List<Departamento>>(
            future: fetchPostd(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                for (int i = 0; i < snapshot.data.length; i++) {
                  var item = snapshot.data[i];
                  departamento.add(item.nombre);
                }

                return SearchableDropdown.single(
                    items: departamento
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropdownValue,
                    hint: "Elige un departaento",
                    searchHint: "Elige un departaento",
                    onChanged: (value) {
                      if (value == null) {
                        dropdownValue1 = "Elige un departaento";
                      } else {
                        dropdownValue1 = value;
                        int numero = departamento.indexOf(dropdownValue1);
                        idDep = snapshot.data[numero].id.toString();
                        print(idDep);
                        bloc.getProvicias(idDep);
                      }
                    },
                    isExpanded: true);
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
        downTomprovice()
      ],
    );
  }

  Widget downTomprovice() {
    return Column(
      children: [
        StreamBuilder(
          stream: bloc.listProvicia,
          builder: (_, AsyncSnapshot<List<Provincia>> snapshot) {
            List<String> provincia = [];
            if (snapshot.data != null) {
              for (var province in snapshot.data) {
                provincia.add(province.nombre);
              }
            }
            return snapshot.data != null
                ? SearchableDropdown.single(
                    items:
                        provincia.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropdownValue,
                    hint: "Elige una provincia",
                    searchHint: "Elige una provincia",
                    onChanged: (value) {
                      if (value == null) {
                        dropdownValue1 = "Elige una provincia";
                      } else {
                        dropdownValue2 = value;
                        int numero = provincia.indexOf(dropdownValue2);
                        idProv = snapshot.data[numero].id.toString();
                        print(idProv);
                        bloc.getDistritos(idProv);
                      }
                    },
                    isExpanded: true)
                : Text("");
          },
        ),
        downTomdistrit(),
      ],
    );
  }

  Widget downTomdistrit() {
    return StreamBuilder(
      stream: bloc.listDistritos,
      builder: (_, AsyncSnapshot<List<Distritos>> snapshot) {
        List<String> distritos = [];
        if (snapshot.data != null) {
          for (var distrit in snapshot.data) {
            distritos.add(distrit.nombre);
          }
        }
        return snapshot.data != null
            ? SearchableDropdown.single(
                items: distritos.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: dropdownValue,
                hint: "Elige un distrito",
                searchHint: "Elige un distrito",
                onChanged: (value) {
                  if (value == null) {
                    dropdownValue3 = "Elige un distrito";
                  } else {
                    dropdownValue3 = value;
                    int numero = distritos.indexOf(dropdownValue3);
                    idDis = snapshot.data[numero].id.toString();
                    print("/////////////////////////////");
                    print(idDis);
                  }
                },
                isExpanded: true)
            : Text("");
      },
    );
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
      hintTextValue: dropdownValue4,
      onChanged: (value) {
        dropdownValue4 = value;

        switch (dropdownValue4) {
          case "Contra Entrega":
            mPago = 1;
            break;
          case "Transferencia Interbancaria":
            mPago = 2;
            break;

          case "Tarjeta Crédito/Débito":
            mPago = 3;
            break;

          case "PayPal":
            mPago = 4;
            break;
        }
        print(mPago);
      },
    );
  }

  Widget _crearDropDownEnvio(BuildContext context) {
    ////////////////////////////////////////////////
    return FutureBuilder<List<MetodosEnvio>>(
        future: fetchPostMEN(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.length; i++) {
              var item = snapshot.data[i];

              mEnvios
                  .add(item.nombre.toUpperCase() + "  :  " + item.descripcion);
            }
            return SearchableDropdown.single(
                items: mEnvios.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: dropdownValue,
                hint: "Metodo de Envío",
                searchHint: "Metodo de Envío",
                onChanged: (value) {
                  if (value == null) {
                    dropdownValue1 = "Metodo de Envío";
                  } else {
                    dropdownValue5 = value;
                    int numero = mEnvios.indexOf(dropdownValue5);
                    mEnvio = snapshot.data[numero].id;
                    precioEnvio = snapshot.data[numero].costo;
                    nombreEnvio = snapshot.data[numero].nombre.toString();
                    print(mEnvio);

                    Provider.of<UsersProviders>(context, listen: false).envio =
                        precioEnvio;
                    listado.clear();

                    mEnvios.clear();
                  }
                },
                isExpanded: true);
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

  Future cuponExiste() async {
    final response = await http.post(
        Uri.parse(
            "http://18.228.156.121/casita/listar/subitems/couponList.php"),
        body: {"codigo": cuponT.text});

    var datauser = json.decode(response.body);
    print(datauser.toString());

    if (datauser.toString() == "[]") {
      idCupon = "";
      precioCupon = 0;
      fechaCupon = "";

      Provider.of<UsersProviders>(context, listen: false).cupon = 0.0;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            cuponT.text = "";

            return AlertDialog(
              content: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  ),
                  Text("   El cupón no existe")
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
    } else {
      idCupon = datauser[0]['CODIGO_CUPON'];
      precioCupon = double.parse(datauser[0]['IMPORTE']);
      fechaCupon = datauser[0]['FECHA_EXPIRACION'];
      Provider.of<UsersProviders>(context, listen: false).cupon = precioCupon;
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
                  Text("   Cupón Aplicado"),
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

  Future addOrder() async {
    final response = await http.post(
        Uri.parse("http://18.228.156.121/casita/insertar/order/addOrder.php"),
        body: {
          "pago": mPago.toString(),
          "envio": mEnvio.toString(),
          "usuario": usuario,
          "total": Provider.of<UsersProviders>(context, listen: false)
              .total
              .toString(),
          "direccion": direccionT.text,
          "distrito": idDis,
        });

    var datauser = json.decode(response.body);
    if (datauser.toString() == "Ingresado") {}
    if (datauser.toString() == "Error") {
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
                  Text("   Error de red")
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

  Future addOrderDetail(String item, String cantidad) async {
    final response2 = await http.post(
        Uri.parse(
            "http://18.228.156.121/casita/insertar/order/addDetailOrder.php"),
        body: {"usuario": usuario, "idProducto": item, "cantidad": cantidad});

    var datauser = json.decode(response2.body);
    if (datauser.toString() == "Ingresado") {
      print("ingresoooooo");
    }
    if (datauser.toString() == "Error") {
      print("un error");
    }
  }

  Future addCoupon() async {
    final response2 = await http.post(
        Uri.parse("http://18.228.156.121/casita/insertar/order/addCoupon.php"),
        body: {"usuario": usuario, "idCupon": idCupon});

    var datauser = json.decode(response2.body);
    if (datauser.toString() == "Ingresado") {
      print("ingresoooooo");
    }
    if (datauser.toString() == "Error") {
      print("un error");
    }
  }
}

class ListarPedidosItems extends StatelessWidget {
  final PedidosList lista;
  ListarPedidosItems(this.lista);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.pending_actions_rounded,
        color: Colors.pink[400],
        size: 30,
      ),
      onLongPress: () {},
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return MiDialogoEditarPedido(lista.estado);
            });
      },
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 10, 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "#:" +
                          lista.id.toString() +
                          "   " +
                          lista.nombre +
                          " " +
                          lista.apellido,
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
                  Text(lista.estado),
                  Text(
                    "S./ " + lista.total.toString(),
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

class MiDialogoEditarPedido extends StatelessWidget {
  final String estado;
  MiDialogoEditarPedido(this.estado);

  @override
  Widget build(BuildContext context) {
    List<String> mPagos = ["Procesando", "Cancelado", "Enviado", "Completado"];
    int mPago; //METODO DE PAGO PARA LA TABLA PEDIDOS
    String dropdownValue4 = estado;
    return AlertDialog(
      title: Text('Estado del pedido'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          estado == "Completado" || estado == "Cancelado"
              ? Text("Pedido " + estado)
              : DropdownWidget(
                  items: mPagos.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                            color: Colors.black87,
                          )),
                    );
                  }).toList(),
                  hintTextValue: dropdownValue4,
                  onChanged: (value) {
                    dropdownValue4 = value;

                    switch (dropdownValue4) {
                      case "Contra Entrega":
                        mPago = 1;
                        break;
                      case "Transferencia Interbancaria":
                        mPago = 2;
                        break;

                      case "Tarjeta Crédito/Débito":
                        mPago = 3;
                        break;

                      case "PayPal":
                        mPago = 4;
                        break;
                    }
                    print(mPago);
                  },
                )
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')),
        TextButton(onPressed: () {}, child: Text('Guardar'))
      ],
    );
  }
}
