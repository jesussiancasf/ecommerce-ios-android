import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriaLista {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;

  CategoriaLista({this.id, this.nombre, this.descripcion, this.imagen});
  factory CategoriaLista.fromJson(Map<String, dynamic> json) {
    return CategoriaLista(
      id: json['ID_CATEGORIA'],
      nombre: json['NOMBRE_CATEGORIA'],
      descripcion: json['DESCRIPCION'],
      imagen: json['IMAGEN_CATEGORIA'],
    );
  }
}

Future<List<CategoriaLista>> fetchPostCAT() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listCategory.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => CategoriaLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
