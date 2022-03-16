import 'package:http/http.dart' as http;
import 'dart:convert';

class DetallePedidoQuery {
  final String nombre;
  final double precio;
  final double precioDescuento;
  final String imagen;
  final int cantidad;

  DetallePedidoQuery(
      {this.nombre,
      this.precio,
      this.precioDescuento,
      this.imagen,
      this.cantidad});
  factory DetallePedidoQuery.fromJson(Map<String, dynamic> json) {
    return DetallePedidoQuery(
      nombre: json['NOMBRE_PRODUCTO'],
      precio: double.parse(json['PRECIO']),
      precioDescuento: json['PRECIO_REDUCIDO'] == null
          ? 0
          : double.parse(json['PRECIO_REDUCIDO']),
      imagen: json['IMAGEN_PRODUCTO'],
      cantidad: int.parse(json['CANTIDAD']),
    );
  }
}

Future<List<DetallePedidoQuery>> fetchPostDPQL(String idPedido) async {
  final response = await http.post(
      Uri.parse("http://18.228.156.121/casita/listar/productOrderQuery.php"),
      body: {"idPedido": idPedido});

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => DetallePedidoQuery.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
