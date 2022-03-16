import 'package:http/http.dart' as http;
import 'dart:convert';

class PedidosList {
  final int id;
  final String nombre;
  final String apellido;
  final String estado;
  final String fecha;
  final double total;

  PedidosList(
      {this.id,
      this.nombre,
      this.apellido,
      this.estado,
      this.fecha,
      this.total});
  factory PedidosList.fromJson(Map<String, dynamic> json) {
    return PedidosList(
        id: int.parse(json["ID_PEDIDO"]),
        nombre: json['NOMBRE'],
        apellido: json['APELLIDO'],
        estado: json['DESCRIPCION_ESTADO'],
        fecha: json['FECHA_PEDIDO'],
        total: double.parse(json['TOTAL']));
  }
}

Future<List<PedidosList>> fetchPostPED() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listOrders.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => PedidosList.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
