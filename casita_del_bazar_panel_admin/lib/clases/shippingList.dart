import 'package:http/http.dart' as http;
import 'dart:convert';

class EnviosLista {
  final String id;
  final String metodo;
  final double costo;
  final String descripcion;

  EnviosLista({this.id, this.metodo, this.costo, this.descripcion});
  factory EnviosLista.fromJson(Map<String, dynamic> json) {
    return EnviosLista(
        id: json['ID_METODO'],
        metodo: json['METODO'],
        costo: double.parse(json['COSTO']),
        descripcion: json["DESCRIPCION"]);
  }
}

Future<List<EnviosLista>> fetchPostSML() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listShipping.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => EnviosLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
