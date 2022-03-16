import 'package:http/http.dart' as http;
import 'dart:convert';

class UserQuery {
  final String usuario;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String direccion;
  final String departamento;
  final String provincia;
  final String distrito;
  final String rol;
  final String imagen;

  UserQuery(
      {this.usuario,
      this.nombre,
      this.apellido,
      this.telefono,
      this.email,
      this.direccion,
      this.departamento,
      this.provincia,
      this.distrito,
      this.rol,
      this.imagen});

  factory UserQuery.fromJson(Map<String, dynamic> json) {
    return UserQuery(
        usuario: json['ID_USUARIO'],
        nombre: json['NOMBRE'],
        apellido: json['APELLIDO'],
        telefono: json['TELEFONO'] == null
            ? "Telefono Desconocido"
            : json['TELEFONO'],
        email: json['EMAIL'],
        direccion: json['DIRECCION'] == null
            ? "Dirección Desconocida"
            : json['DIRECCION'],
        departamento: json['DEPARTAMENTO_NOMBRE'],
        provincia: json['PROVINCIA_NOMBRE'],
        distrito: json['DISTRITO_NOMBRE'],
        rol: json['NOMBRE_ROL'],
        imagen: json['IMAGEN']);
  }
}

Future<List<UserQuery>> fetchPostUQ() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/userQuery.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => UserQuery.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
