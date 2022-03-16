import 'package:http/http.dart' as http;
import 'dart:convert';

class MetodosEnvio {
  final int id;
  final String nombre;
  final double costo;
  final String descripcion;

  MetodosEnvio({this.id, this.nombre, this.costo, this.descripcion});

  factory MetodosEnvio.fromJson(Map<String, dynamic> json) {
    return MetodosEnvio(
      id: int.parse(json['ID_METODO']),
      nombre: json['METODO'],
      costo: double.parse(json['COSTO']),
      descripcion: json['DESCRIPCION'],
    );
  }
}

Future<List<MetodosEnvio>> fetchPostMEN() async {
  final response = await http.get(Uri.parse(
      'http://18.228.156.121/casita/listar/subitems/shippingMethods.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => MetodosEnvio.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
