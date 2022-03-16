import 'dart:convert';

import 'package:casita_del_bazar_panel_admin/clases/cuponList.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cupones extends StatefulWidget {
  @override
  _CuponesState createState() => _CuponesState();
}

class _CuponesState extends State<Cupones> {
  String _fecha = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _codigoT = new TextEditingController();
  TextEditingController _importeT = new TextEditingController();
  TextEditingController _stockT = new TextEditingController();

  Future addCoupon() async {
    String _cuponM = _codigoT.text.toUpperCase();

    final response = await http.post(
        Uri.parse("http://18.228.156.121/casita/insertar/addCoupon.php"),
        body: {
          "codigo": _cuponM,
          "importe": _importeT.text,
          "stock": _stockT.text,
          "fecha": _inputFieldDateController.text,
        });

    var datauser = json.decode(response.body);
    if (datauser.toString() == "Ingresado") {
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
                  Text("   Cupón registrado"),
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

  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Cupones',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<CuponesLista>>(
          future: fetchPostcu(),
          builder: (BuildContext contetxt, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return ListarCupones(items);
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
      floatingActionButton: _agregarBotonesFlotantes(context),
    );
  }

////////////////////////////////////////////////////////////

  ///

  Widget _agregarBotonesFlotantes(BuildContext context) {
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
        SizedBox(
          width: 5,
        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => _mostrarAlerta(context),
          child: Icon(Icons.add),
        ),
      ],
    );
  }
/////////////////////////////////////////////////////////////////////////////

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar Cupón'),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _crearInput('Codigo de cupón', Icon(Icons.closed_caption),
                          _codigoT),
                      _crearInput(
                          'Importe', Icon(Icons.attach_money), _importeT),
                      _crearInput('Cantidad de cupones',
                          Icon(Icons.unfold_more), _stockT),
                      _crearFecha(context, 'Fecha de caducidad'),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _importeT.text = "";
                    _stockT.text = "";
                    _codigoT.text = "";
                    _inputFieldDateController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    if (_importeT.text == "" ||
                        _stockT.text == "" ||
                        _codigoT.text == "" ||
                        _inputFieldDateController.text == "") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Algunos Campos estan vacíos"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Aceptar"))
                              ],
                            );
                          });
                    } else {
                      addCoupon();
                      _importeT.text = "";
                      _stockT.text = "";
                      _codigoT.text = "";
                      _inputFieldDateController.text = "";
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Guardar'))
            ],
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////
  Widget _crearInput(
      String campo, Icon icono, TextEditingController controler) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: TextField(
        autofocus: false,
        controller: controler,
        decoration: InputDecoration(
          hintText: '$campo',
          icon: icono,
          labelText: '$campo',
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////
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
          _selectDate(context);
        },
      ),
    );
  }

  //////////////////////////////////////////////////////////////////

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),

      //   locale: Locale('es', 'ES')
    );

    if (picked != null) {
      setState(() {
        _fecha = picked.toString();
        _inputFieldDateController.text = _fecha;
      });
    }
  }
}

class ListarCupones extends StatelessWidget {
  final CuponesLista lista;
  ListarCupones(this.lista);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Eliminar cupón"),
                content: Row(
                  children: [
                    Text(lista.codigo.toUpperCase() +
                        " de " +
                        lista.importe.toString() +
                        " soles")
                  ],
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
                      deleteData(lista.codigo, context);
                    },
                    child: Text("Sí"),
                  ),
                ],
              );
            });
      },
      leading: Icon(
        Icons.confirmation_num_sharp,
        size: 40,
        color: Colors.pink,
      ),
      onTap: () {
        print(lista.codigo);
      },
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
        child: Row(
          children: [
            Expanded(
              child: Text(lista.codigo + "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Expanded(
              child: Text("" + lista.importe.toString() + " Soles",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.green)),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("stock " + lista.stock.toString()),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Future deleteData(String id, BuildContext context) async {
    final response2 = await http.post(
        Uri.parse("http://18.228.156.121/casita/eliminar/deleteCoupon.php"),
        body: {"codCupon": id});

    var datauser = json.decode(response2.body);
    if (datauser.toString() == "Ingresado") {
      Navigator.of(context).pop();
    }
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
