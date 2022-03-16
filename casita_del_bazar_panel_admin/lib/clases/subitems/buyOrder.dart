import 'package:http/http.dart' as http;
import 'dart:convert';

class ComprasListadoItem {
  final int id;
  final String fecha;
  final double monto;

  ComprasListadoItem({this.id, this.fecha, this.monto});
  factory ComprasListadoItem.fromJson(Map<String, dynamic> json) {
    return ComprasListadoItem(
      id: int.parse(json['ID_COMPRA']),
      fecha: json['FECHA_COMPRA'],
      monto: double.parse(json['MONTO']),
    );
  }
}

Future<List<ComprasListadoItem>> fetchPostCLI() async {
  final response = await http.get(
      Uri.parse('http://18.228.156.121/casita/listar/subitems/buyOrder.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => ComprasListadoItem.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
