import 'package:http/http.dart' as http;
import 'dart:convert';

class Distritos {
  final String nombre;
  final String id;

  Distritos({this.nombre, this.id});
  factory Distritos.fromJson(Map<String, dynamic> json) {
    return Distritos(
      nombre: json['DISTRITO_NOMBRE'],
      id: json['ID_DISTRITO'],
    );
  }
}

Future<List<Distritos>> fetchPostdis(String idProv) async {
  final response = await http.post(
      Uri.parse("http://18.228.156.121/casita/listar/ubicacion/distrito.php"),
      body: {"id_provincia": idProv});

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => Distritos.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
