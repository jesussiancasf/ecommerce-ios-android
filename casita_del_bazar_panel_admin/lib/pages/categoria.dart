import 'dart:convert';
import 'dart:io';

import 'package:casita_del_bazar_panel_admin/clases/categoryList.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Categoria extends StatefulWidget {
  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Categorias',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<CategoriaLista>>(
          future: fetchPostCAT(),
          builder: (BuildContext contetxt, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return ListarItemsCategoria(items);
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
          return MiDialogoCategoria();
        });
  }
}

class ListarItemsCategoria extends StatelessWidget {
  final CategoriaLista lista;
  ListarItemsCategoria(this.lista);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        if (lista.id == "otros") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("No se puede eliminar"),
                  content: Row(
                    children: [Text("Categoría " + lista.nombre)],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Aceptar"),
                    ),
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Eliminar categoria"),
                  content: Row(
                    children: [Text(lista.nombre)],
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
        }
      },
      onTap: () {
        print(lista.id);
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
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lista.nombre,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(
                    lista.descripcion,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future deleteData(String id, BuildContext context) async {
    final response2 = await http.post(
        Uri.parse("http://18.228.156.121/casita/eliminar/deleteCategory.php"),
        body: {"idCategoria": id});

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

class MiDialogoCategoria extends StatefulWidget {
  MiDialogoCategoria({Key key}) : super(key: key);

  @override
  _MiDialogoCategoriaState createState() => _MiDialogoCategoriaState();
}

class _MiDialogoCategoriaState extends State<MiDialogoCategoria> {
  TextEditingController idT = new TextEditingController();
  TextEditingController nombreT = new TextEditingController();
  TextEditingController descripcionT = new TextEditingController();
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

  Future addCategory(BuildContext context) async {
    final uri =
        Uri.parse("http://18.228.156.121/casita/insertar/addCategory.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = idT.text;
    request.fields['nombre'] = nombreT.text;
    request.fields['descripcion'] = descripcionT.text;

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
      title: Text('Agregar Categoría'),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            _crearInput('Id', Icon(Icons.vpn_key), idT),
            _crearInput('Nombre', Icon(Icons.category), nombreT),
            _crearInput('Descripción', Icon(Icons.receipt), descripcionT),
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
                    child: Text('Cargar imagen de categoría'),
                  ),
                ),
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
              print(idT.text);
              print(nombreT.text);
              print(descripcionT.text);
              print(_image.path);
              addCategory(context);
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
