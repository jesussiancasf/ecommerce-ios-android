import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioLogeado {
  final String usuario;
  final String rol;

  UsuarioLogeado(this.usuario, this.rol);
}

class UsuarioHomePage {
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;

  final String imagen;

  UsuarioHomePage(
      {this.nombre, this.apellido, this.telefono, this.email, this.imagen});
  factory UsuarioHomePage.fromJson(Map<String, dynamic> json) {
    return UsuarioHomePage(
        nombre: json['NOMBRE'],
        apellido: json['APELLIDO'],
        telefono: json['TELEFONO'],
        email: json["EMAIL"],
        imagen: json["IMAGEN"]);
  }
}

Future<List<UsuarioHomePage>> fetchPosthp(String id) async {
  final response = await http.post(
      Uri.parse('http://18.228.156.121/casita/home.php'),
      body: {"usuario": id});
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => UsuarioHomePage.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
