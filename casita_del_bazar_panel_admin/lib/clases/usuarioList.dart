import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuariosLista {
  final String usuario;
  final String nombre;
  final String apellido;
  final String rol;
  final String imagen;

  UsuariosLista(
      {this.usuario, this.nombre, this.apellido, this.rol, this.imagen});
  factory UsuariosLista.fromJson(Map<String, dynamic> json) {
    return UsuariosLista(
        usuario: json['ID_USUARIO'],
        nombre: json['NOMBRE'],
        apellido: json['APELLIDO'],
        rol: json["NOMBRE_ROL"],
        imagen: json["IMAGEN"]);
  }
}

Future<List<UsuariosLista>> fetchPost() async {
  final response = await http.get(
      Uri.parse('http://18.228.156.121/casita/listar/listar_usuarios.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => UsuariosLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
