import 'package:http/http.dart' as http;
import 'dart:convert';

class CuponesLista {
  final String codigo;
  final double importe;
  final int stock;

  CuponesLista({this.codigo, this.importe, this.stock});
  factory CuponesLista.fromJson(Map<String, dynamic> json) {
    return CuponesLista(
        codigo: json['CODIGO_CUPON'],
        importe: double.parse(json['IMPORTE']),
        stock: int.parse(json["STOCK"]));
  }
}

Future<List<CuponesLista>> fetchPostcu() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listCoupon.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => CuponesLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
