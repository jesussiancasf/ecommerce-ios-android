import 'dart:convert';
import 'dart:io';

import 'package:casita_del_bazar_panel_admin/clases/productsList.dart';
import 'package:casita_del_bazar_panel_admin/clases/subitems/category.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Productos extends StatefulWidget {
  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Productos',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<ProductosListado>>(
          future: fetchPostPRL(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return ListarProductsItemsL(items);
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

//////////////////////////////////////////////////////////////////////////

  Widget _agregarBotonesFlotantes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            setState(() {});
          },
          child: Icon(Icons.replay),
        ),
        SizedBox(
          width: 5,
        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            _mostrarAlerta(context);
          },
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
          return MiDialogoProducto();
        });
  }
}

class MiDialogoProducto extends StatefulWidget {
  @override
  _MiDialogoProductoState createState() => _MiDialogoProductoState();
}

class _MiDialogoProductoState extends State<MiDialogoProducto> {
  TextEditingController nombreT = new TextEditingController();
  TextEditingController descripcionT = new TextEditingController();
  TextEditingController pesoT = new TextEditingController();
  TextEditingController precioT = new TextEditingController();
  TextEditingController precioReducidoT = new TextEditingController();
  int stock = 0;
  String idCategoria = "";
  double precioReducido = 0;
  String dropdownValue = "Categoría";

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
  }

  Future addProduct(BuildContext context) async {
    final uri =
        Uri.parse("http://18.228.156.121/casita/insertar/addProduct.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['nombre'] = nombreT.text;
    request.fields['descripcion'] = descripcionT.text;
    request.fields['peso'] = pesoT.text;
    request.fields['precio'] = precioT.text;
    request.fields['precioReducido'] = precioReducido.toString();
    request.fields['id_categoria'] = idCategoria;
    request.fields['stock'] = stock.toString();

    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
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
                  Text("   Usuario ingresado con exito")
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Producto'),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Aqui va todo el contenido

                _crearInput('Nombre', Icon(Icons.category), nombreT),
                _crearInput('Descripción', Icon(Icons.receipt), descripcionT),
                _crearInput('Peso', Icon(Icons.arrow_downward), pesoT),
                _crearInput('Precio', Icon(Icons.attach_money), precioT),
                _crearInput(
                    'Precio descuento', Icon(Icons.money_off), precioReducidoT),

                SizedBox(
                  height: 15,
                ),
              ],
            ),
            _crearDropDownAnidado(context),
            SizedBox(
              height: 5,
            ),
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
              precioReducidoT.text == ""
                  ? precioReducido = 0
                  : precioReducido = double.parse(precioReducidoT.text);

              addProduct(context);
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

  Widget _crearDropDownAnidado(BuildContext context) {
    List<String> categorias = [];

    ////////////////////////////////////////////////
    return Column(
      children: [
        FutureBuilder<List<Categorias>>(
            future: fetchPostCA(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                for (int i = 0; i < snapshot.data.length; i++) {
                  var item = snapshot.data[i];
                  categorias.add(item.nombre);
                }
                return StatefulBuilder(builder: (context, setState) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        hint: Text(dropdownValue),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            int numero = categorias.indexOf(dropdownValue);
                            idCategoria = snapshot.data[numero].id.toString();
                          });
                        },
                        items: categorias
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ));
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
            }),
      ],
    );
  }
}

class ListarProductsItemsL extends StatelessWidget {
  final ProductosListado lista;

  ListarProductsItemsL(this.lista);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Eliminar producto"),
                content: Row(
                  children: [Text(lista.id.toString() + " " + lista.nombre)],
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
      onTap: () {
        print(lista.nombre);
      },
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
        child: Row(
          children: [
            Image.network(
              lista.imagen,
              width: 50,
              height: 50,
            ),
            SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID:" + lista.id.toString() + "   " + lista.nombre,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(lista.categoria, style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text("Stock: " + lista.stock.toString()),
                  lista.precioReducido != 0
                      ? Text(
                          "S./ " + lista.precioReducido.toString(),
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "S./ " + lista.precio.toString(),
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

  Future deleteData(String id, BuildContext context) async {
    final response2 = await http.post(
        Uri.parse("http://18.228.156.121/casita/eliminar/deleteProducts.php"),
        body: {"idProducto": id});

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
