import 'dart:convert';
import 'dart:io';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/departamento.dart';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/distrito.dart';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/provincia.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/clases/usuarioList.dart';
import 'package:casita_del_bazar_panel_admin/streams/locationsStream.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:casita_del_bazar_panel_admin/utils/dropdownbutton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Usuarios extends StatefulWidget {
  @override
  _UsuariosState createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;
    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Usuarios',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: FutureBuilder<List<UsuariosLista>>(
          future: fetchPost(),
          builder: (BuildContext contetxt, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var items = snapshot.data[index];

                    return ListarItems(items);
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

////////////////////////////////////////////////////////////////////////////////////////////

  Widget _agregarBotonesFlotantes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            setState(() {});
          },
          child: Icon(Icons.refresh),
        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => _mostrarAlerta(context),
          child: Icon(Icons.add),
        ),
      ],
    );
  }

////////////////////////////////////////////////////////////////////////////////
  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MiDialogoUsuario();
        });
  }

  ///////////////////////////////////////////////////////////////
  /*FIN DE PAGINA USUARIOS */
  //////////////////////////////////////////////////////////////////
  ///INICIO DE LISTAR USUARIOS

}

class ListarItems extends StatelessWidget {
  final UsuariosLista lista;
  ListarItems(this.lista);
  @override
  Widget build(BuildContext context) {
    TextStyle estilo = TextStyle(
        color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15);
    if (lista.rol.toString() == "Repartidor") {
      estilo = TextStyle(
          color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15);
    }
    if (lista.rol.toString() == "Cliente") {
      estilo = TextStyle(
          color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15);
    }

    return ListTile(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Eliminar usuario " + lista.usuario),
                content: Row(
                  children: [Text(lista.nombre + " " + lista.apellido)],
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
                      deleteData(lista.usuario.toString(), context);
                    },
                    child: Text("Sí"),
                  ),
                ],
              );
            });
      },
      onTap: () {
        print(lista.usuario);
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(lista.usuario + "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 10),
                    Text(
                      lista.rol,
                      style: estilo,
                    ),
                  ],
                ),
                Text(lista.nombre + " " + lista.apellido,
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future deleteData(String id, BuildContext context) async {
    final response2 = await http.post(
        Uri.parse("http://18.228.156.121/casita/eliminar/deleteUser.php"),
        body: {"idUsuario": id});

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

///////////////////////////////////////////////////////////////
/*FIN DE LISTAR USUARIOS */
//////////////////////////////////////////////////////////////////
///INICIO DE ALERT DIALOG

class MiDialogoUsuario extends StatefulWidget {
  @override
  _MiDialogoUsuarioState createState() => _MiDialogoUsuarioState();
}

class _MiDialogoUsuarioState extends State<MiDialogoUsuario> {
  LocationStream bloc = new LocationStream();
  final estiloTexto = TextStyle(color: Colors.blue, fontSize: 15);
  TextEditingController usuarioT = new TextEditingController();
  TextEditingController nombreT = new TextEditingController();
  TextEditingController apellidoT = new TextEditingController();
  TextEditingController direccionT = new TextEditingController();
  TextEditingController emailT = new TextEditingController();
  TextEditingController telefonoT = new TextEditingController();
  TextEditingController controlPassT = new TextEditingController();
  ////////////////////////////
  String dropdownValue = "Departamento";
  String dropdownValue2 = "Provincia";
  String dropdownValue3 = "Distrito";
  String idDep = "";
  String idProv = "";
  String idDis = "";
/////////////////////////////////////////////////////

  String idRol = "";
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

  Future addUser(BuildContext context) async {
    final uri = Uri.parse("http://18.228.156.121/casita/insertar/addUser.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['usuario'] = usuarioT.text;
    request.fields['nombre'] = nombreT.text;
    request.fields['apellido'] = apellidoT.text;
    request.fields['telefono'] = telefonoT.text;
    request.fields['email'] = emailT.text;
    request.fields['direccion'] = direccionT.text;
    request.fields['contrasena'] = controlPassT.text;
    request.fields['id_distrito'] = idDis;
    request.fields['id_rol'] = idRol;
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
      title: Text('Agregar Usuario'),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _crearInput(
                    'Nombre de usuario', Icon(Icons.perm_identity), usuarioT),
                _crearInput('Nombres', Icon(Icons.perm_identity), nombreT),
                _crearInput('Apellidos', Icon(Icons.perm_identity), apellidoT),
                _crearInputPass(
                    "Contraseña", Icon(Icons.vpn_key_sharp), controlPassT),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 15, 0, 0),
                  child: Text(
                    'Dirección',
                    style: estiloTexto,
                  ),
                ),

                _crearDropDownAnidado(context),
                _crearInput(
                    'Dirección', Icon(Icons.store_mall_directory), direccionT),
                _crearInput('Email', Icon(Icons.email), emailT),
                _crearInput('Telefono', Icon(Icons.phone), telefonoT),

///////////////////////////////////////////////////////////////////////////////////
              ],
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
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            elegirImagen();
                          },
                          child: Text('Cargar imagen de perfil'),
                        ),
                      ],
                    )),
              ],
            ),
            _crearDropDownMenu('Rol', 'Administrador', 'Repartidor', 'Cliente'),
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
              if (usuarioT.text == "" ||
                  nombreT.text == "" ||
                  apellidoT.text == "" ||
                  telefonoT.text == "" ||
                  emailT.text == "" ||
                  direccionT.text == "") {
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
                addUser(context);
              }
              /*print(usuarioT.text);
              print(nombreT.text);
              print(apellidoT.text);
              print(telefonoT.text);
              print(emailT.text);
              print(direccionT.text);
              print(controlPassT.text);
              print("200501");
              print(idRol);
              print(_image.path);*/
            },
            child: Text('Guardar'))
      ],
    );
  }

  ///////////////////////////////////////////////////////////////
  /*FIN DE DIALOG */
  //////////////////////////////////////////////////////////////////
  ///INICIO DE FUNCIONES DIALOG

  Widget _crearInput(
      String campo, Icon icono, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: TextField(
        controller: textEditingController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: '$campo',
          icon: icono,
          labelText: '$campo',
        ),
      ),
    );
  }

  Widget _crearInputPass(
      String campo, Icon icono, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: TextField(
        controller: textEditingController,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: '$campo',
          icon: icono,
          labelText: '$campo',
        ),
      ),
    );
  }

  Widget _crearDropDownMenu(
      String dropdownValue, String a, String b, String c) {
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
                if (dropdownValue == "Administrador") {
                  idRol = "admin";
                }
                if (dropdownValue == "Repartidor") {
                  idRol = "repart";
                }
                if (dropdownValue == "Cliente") {
                  idRol = "client";
                }
                print(idRol);
              });
            },
            items: <String>[
              '$a',
              '$b',
              '$c',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ));
    });
  }

  //////////////////////////////////////////////////////////
  ///
  //////DROPDOWNLIST ANIDADOS ->>>
  //////////////////////////////////////////////////////////

  Widget _crearDropDownAnidado(BuildContext context) {
    //Future<List<Provincia>> prov = fetchPostp("01");
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
                            int numero = departamento.indexOf(dropdownValue);
                            idDep = snapshot.data[numero].id.toString();
                            print(idDep);
                            bloc.getProvicias(idDep);
                          });

                          //bloc.getProvicias(idDep);
                          /*setState(() {
                            //print("CAMBIA ESTADO");
                          });*/
                        },
                        items: departamento
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
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child: DropdownWidget<String>(
                      hintTextValue: dropdownValue2,
                      onChanged: (value) {
                        setState(() {
                          dropdownValue2 = value;
                          int numero = provincia.indexOf(dropdownValue2);
                          idProv = snapshot.data[numero].id.toString();
                          print(idProv);
                          bloc.getDistritos(idProv);
                        });
                      },
                      items: provincia
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(value,
                              style: TextStyle(
                                color: Colors.black45,
                              )),
                          value: value,
                        );
                      }).toList(),
                    ),
                  )
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
            ? Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: DropdownWidget<String>(
                  hintTextValue: dropdownValue3,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue3 = value;
                      int numero = distritos.indexOf(dropdownValue3);
                      idDis = snapshot.data[numero].id.toString();
                      print(idDis);
                    });
                  },
                  items:
                      distritos.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child:
                          Text(value, style: TextStyle(color: Colors.black45)),
                      value: value,
                    );
                  }).toList(),
                ),
              )
            : Text("");
      },
    );
  }
}

///////////////////////////////////////////////////////////////
/*FIN DE FUNCIONES DIALOG */
//////////////////////////////////////////////////////////////////
///INICIO DE WIDGETS
