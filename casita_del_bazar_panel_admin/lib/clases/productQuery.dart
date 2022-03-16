import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductQuery {
  final int id;
  final String nombre;
  final String descripcion;
  final double peso;
  final String imagen;
  final double precio;
  final double precioDescuento;
  final String categoria;
  final int stock;

  ProductQuery(
      {this.id,
      this.nombre,
      this.descripcion,
      this.peso,
      this.imagen,
      this.precio,
      this.precioDescuento,
      this.categoria,
      this.stock});
  factory ProductQuery.fromJson(Map<String, dynamic> json) {
    return ProductQuery(
      id: int.parse(json['ID_PRODUCTO']),
      nombre: json['NOMBRE_PRODUCTO'],
      descripcion: json['DESCRIPCION'],
      peso: double.parse(json['PESO']),
      imagen: json['IMAGEN_PRODUCTO'],
      precio: double.parse(json['PRECIO']),
      precioDescuento: json['PRECIO_REDUCIDO'] == null
          ? 0
          : double.parse(json['PRECIO_REDUCIDO']),
      categoria: json['NOMBRE_CATEGORIA'],
      stock: int.parse(json['STOCK']),
    );
  }
}

Future<List<ProductQuery>> fetchPostPQ() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/productQuery.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => ProductQuery.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
