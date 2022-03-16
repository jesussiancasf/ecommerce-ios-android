import 'dart:convert';
import 'dart:io';

import 'package:casita_del_bazar_panel_admin/clases/guideList.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/buyOrder.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class GuiaRemision extends StatefulWidget {
  @override
  _GuiaRemisionState createState() => _GuiaRemisionState();
}

class _GuiaRemisionState extends State<GuiaRemision> {
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
              'Guias de Remisión',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white),
        drawer: Drawer(
          child: getListHeaderItems(context, false, _usuario, _rol),
        ),
        body: FutureBuilder<List<GuiasRLista>>(
            future: fetchPostGRL(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length != 0
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var items = snapshot.data[index];
                          return ListarGuiasItems(items);
                        })
                    : Padding(
                        padding: const EdgeInsets.all(82.0),
                        child: Center(
                            child: Text(
                          "Parece que aun no hay guias de remisión",
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
          return MiDialogoGuias();
        });
  }
}

class ListarGuiasItems extends StatelessWidget {
  final GuiasRLista lista;
  ListarGuiasItems(this.lista);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.featured_play_list_outlined,
        color: Colors.pink[400],
        size: 30,
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 10, 8),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Guia " + lista.idGuia.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(lista.fecha, style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(lista.proveedor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MiDialogoGuias extends StatefulWidget {
  MiDialogoGuias({Key key}) : super(key: key);

  @override
  _MiDialogoGuiasState createState() => _MiDialogoGuiasState();
}

class _MiDialogoGuiasState extends State<MiDialogoGuias> {
  TextEditingController numeroT = new TextEditingController();
  TextEditingController descripcionT = new TextEditingController();
  TextEditingController _inputFieldDateController = new TextEditingController();
  String dropdownValue = "Elegir Compra";
  int idCompra;
  List<String> listOrders = [];
  String _fecha = "Selecciona Fecha";
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
    listOrders.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Guia de Remisión'),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                FutureBuilder<List<ComprasListadoItem>>(
                    future: fetchPostCLI(),
                    builder: (BuildContext contetxt, snapshot) {
                      if (snapshot.hasData) {
                        for (int i = 0; i < snapshot.data.length; i++) {
                          var item = snapshot.data[i];
                          listOrders.add("Compra #" +
                              item.id.toString() +
                              "  -  Fecha:" +
                              item.fecha +
                              "  -  Monto:" +
                              item.monto.toString());
                        }

                        return SearchableDropdown.single(
                          items: listOrders
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: dropdownValue,
                          hint: "Elegir Compra",
                          searchHint: "Elegir Compra",
                          onChanged: (value) {
                            if (value == null) {
                              dropdownValue = "Elegir Compra";
                              idCompra = null;
                            } else {
                              dropdownValue = value;
                              idCompra = snapshot
                                  .data[listOrders.indexOf(dropdownValue)].id;
                              print(idCompra);
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
                _crearInput('Identificador de Guia',
                    Icon(Icons.directions_bus_rounded), numeroT),
                _crearInput(
                    'Descripción', Icon(Icons.closed_caption), descripcionT),
                _crearFecha(context, _fecha),
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
                          child: Text('Cargar imagen de Guia'),
                        )),
                  ],
                ),
                SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () {
              if (idCompra == null ||
                  numeroT.text == "" ||
                  _fecha == "Selecciona Fecha" ||
                  _image.path == null) {
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
                            Text("   Algunos Campos estan vacios ")
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
                addRGuide(context);
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
          listOrders.clear();

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
      listOrders.clear();

      _fecha = picked.toString();
      _inputFieldDateController.text = _fecha;
    } else {
      listOrders.clear();
    }
  }

  Future addRGuide(BuildContext context) async {
    final uri = Uri.parse(
        "http://18.228.156.121/casita/insertar/buyOrder/addRGuide.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['numGuia'] = numeroT.text;
    request.fields['idCompra'] = idCompra.toString();
    request.fields['descripcion'] = descripcionT.text;
    request.fields['fecha'] = _fecha;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 && response.body == '"Ingresado"') {
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
                  Text("   Guia ingresada con exito")
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
}
