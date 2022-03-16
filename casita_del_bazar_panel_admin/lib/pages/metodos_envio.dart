import 'dart:convert';

import 'package:casita_del_bazar_panel_admin/clases/shippingList.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MetodosEnvio extends StatefulWidget {
  @override
  _MetodosEnvioState createState() => _MetodosEnvioState();
}

class _MetodosEnvioState extends State<MetodosEnvio> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Métodos de envío',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<EnviosLista>>(
          future: fetchPostSML(),
          builder: (BuildContext contetxt, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return ListarMetodosEnvio(items);
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
        FloatingActionButton(
          heroTag: null,
          onPressed: () => _mostrarAlerta(context),
          child: Icon(Icons.add),
        ),
      ],
    );
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MiDialogoEnvio();
        });
  }
}

class ListarMetodosEnvio extends StatelessWidget {
  final EnviosLista lista;
  ListarMetodosEnvio(this.lista);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Eliminar metodo de envío"),
                content: Row(
                  children: [Text(lista.metodo)],
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
                      deleteData(lista.id.toString(), context);
                    },
                    child: Text("Sí"),
                  ),
                ],
              );
            });
      },
      leading: Icon(
        Icons.directions_bus_rounded,
        size: 40,
        color: Colors.pink,
      ),
      onTap: () {
        print(lista.metodo);
      },
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID:" + lista.id.toString() + "  " + lista.metodo,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(lista.descripcion, style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "S./ " + lista.costo.toString(),
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future deleteData(String id, BuildContext context) async {
    final response2 = await http.post(
        Uri.parse("http://18.228.156.121/casita/eliminar/deleteShipping.php"),
        body: {"idEnvio": id});

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

class MiDialogoEnvio extends StatefulWidget {
  MiDialogoEnvio({Key key}) : super(key: key);

  @override
  _MiDialogoEnvioState createState() => _MiDialogoEnvioState();
}

class _MiDialogoEnvioState extends State<MiDialogoEnvio> {
  TextEditingController metodoT = new TextEditingController();
  TextEditingController descripcionT = new TextEditingController();
  TextEditingController importeT = new TextEditingController();

  Future addShippingMethod(BuildContext context) async {
    final response = await http.post(
        Uri.parse("http://18.228.156.121/casita/insertar/addShipping.php"),
        body: {
          "metodo": metodoT.text,
          "descripcion": descripcionT.text,
          "precio": importeT.text,
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
                  Text("   Metodo agregado")
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
    return AlertDialog(
      title: Text('Agregar Método de envío'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _crearInput('Metodo', Icon(Icons.directions_bus_rounded), metodoT),
          _crearInput('Descripción', Icon(Icons.closed_caption), descripcionT),
          _crearInput('Importe', Icon(Icons.attach_money), importeT),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () {
              if (metodoT.text == "" ||
                  descripcionT.text == "" ||
                  importeT.text == "") {
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
                            Text("   Algunos Campos están vacíos")
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
                addShippingMethod(context);
              }
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
        controller: controller,
        autofocus: false,
        decoration: InputDecoration(
          hintText: '$campo',
          icon: icono,
          labelText: '$campo',
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
