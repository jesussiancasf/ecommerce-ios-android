import 'package:http/http.dart' as http;
import 'dart:convert';

class Provincia {
  final String nombre;
  final String id;

  Provincia({this.nombre, this.id});
  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      nombre: json['PROVINCIA_NOMBRE'],
      id: json['ID_PROVINCIA'],
    );
  }
}

Future<List<Provincia>> fetchPostp(String idDep) async {
  final response = await http.post(
      Uri.parse("http://18.228.156.121/casita/listar/ubicacion/provincia.php"),
      body: {"idDepartamento": idDep});

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => Provincia.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
