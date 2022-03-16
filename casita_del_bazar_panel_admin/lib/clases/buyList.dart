import 'package:http/http.dart' as http;
import 'dart:convert';

class ComprasLista {
  final int id;
  final double monto;
  final String fecha;
  final String empresa;

  ComprasLista({this.id, this.monto, this.fecha, this.empresa});
  factory ComprasLista.fromJson(Map<String, dynamic> json) {
    return ComprasLista(
      id: int.parse(json['ID_COMPRA']),
      monto: double.parse(json['MONTO']),
      fecha: json['FECHA_COMPRA'],
      empresa: json['EMPRESA'],
    );
  }
}

Future<List<ComprasLista>> fetchPostBL() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listBuy.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => ComprasLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
