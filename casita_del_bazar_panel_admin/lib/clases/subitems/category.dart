import 'package:http/http.dart' as http;
import 'dart:convert';

class Categorias {
  final String nombre;
  final String id;

  Categorias({this.nombre, this.id});
  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(
      nombre: json['NOMBRE_CATEGORIA'],
      id: json['ID_CATEGORIA'],
    );
  }
}

Future<List<Categorias>> fetchPostCA() async {
  final response = await http.get(
      Uri.parse('http://18.228.156.121/casita/listar/subitems/category.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => Categorias.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
