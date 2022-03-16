import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductosListado {
  final int id;
  final String nombre;
  final double precio;
  final double precioReducido;
  final int stock;
  final String categoria;
  final String imagen;

  ProductosListado(
      {this.id,
      this.nombre,
      this.precio,
      this.precioReducido,
      this.stock,
      this.categoria,
      this.imagen});
  factory ProductosListado.fromJson(Map<String, dynamic> json) {
    return ProductosListado(
      id: int.parse(json['ID_PRODUCTO']),
      nombre: json['NOMBRE_PRODUCTO'],
      precio: double.parse(json['PRECIO']),
      precioReducido: json['PRECIO_REDUCIDO'] == null
          ? 0
          : double.parse(json['PRECIO_REDUCIDO']),
      stock: int.parse(json['STOCK']),
      categoria: json['NOMBRE_CATEGORIA'],
      imagen: json['IMAGEN_PRODUCTO'],
    );
  }
}

Future<List<ProductosListado>> fetchPostPRL() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listProducts.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => ProductosListado.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
