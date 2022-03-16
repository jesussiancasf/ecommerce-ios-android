import 'package:http/http.dart' as http;
import 'dart:convert';

class Departamento {
  final String nombre;
  final String id;

  Departamento({this.nombre, this.id});
  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      nombre: json['DEPARTAMENTO_NOMBRE'],
      id: json['ID_DEPARTAMENTO'],
    );
  }
}

Future<List<Departamento>> fetchPostd() async {
  final response = await http.get(Uri.parse(
      'http://18.228.156.121/casita/listar/ubicacion/departamento.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => Departamento.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
