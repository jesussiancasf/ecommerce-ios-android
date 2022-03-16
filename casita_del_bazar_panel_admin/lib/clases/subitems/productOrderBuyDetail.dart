import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalleCompraQuery {
  final String nombre;
  final double precio;
  final String imagen;
  final int cantidad;

  DetalleCompraQuery({this.nombre, this.precio, this.imagen, this.cantidad});
  factory DetalleCompraQuery.fromJson(Map<String, dynamic> json) {
    return DetalleCompraQuery(
      nombre: json['NOMBRE_PRODUCTO'],
      precio: double.parse(json['PRECIO_COMPRA']),
      imagen: json['IMAGEN_PRODUCTO'],
      cantidad: int.parse(json['CANTIDAD']),
    );
  }
}

Future<List<DetalleCompraQuery>> fetchPostDCQL(String idCompra) async {
  final response = await http.post(
      Uri.parse(
          "http://18.228.156.121/casita/listar/orderBuyProductDetail.php"),
      body: {"idCompra": idCompra});

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => DetalleCompraQuery.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
