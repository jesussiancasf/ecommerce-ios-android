import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuariosWidget {
  final String id;
  final String nombre;
  final String apellido;

  UsuariosWidget({this.id, this.nombre, this.apellido});
  factory UsuariosWidget.fromJson(Map<String, dynamic> json) {
    return UsuariosWidget(
      id: json['ID_USUARIO'],
      nombre: json['NOMBRE'],
      apellido: json['APELLIDO'],
    );
  }
}

Future<List<UsuariosWidget>> fetchPostUWL() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/subitems/users.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => UsuariosWidget.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
