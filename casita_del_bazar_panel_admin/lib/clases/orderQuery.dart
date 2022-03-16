import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderQuery {
  final int id;
  final String fecha;
  final String metodoPago;
  final String metodoEnvio;
  final String estadoPedido;
  final String nombre;
  final String apellido;
  final double total;
  final String direccion;
  final String departamento;
  final String provincia;
  final String distrito;
  final String telefono;
  final String email;
  final double costoEnvio;

  OrderQuery(
      {this.id,
      this.fecha,
      this.metodoPago,
      this.metodoEnvio,
      this.estadoPedido,
      this.nombre,
      this.apellido,
      this.total,
      this.direccion,
      this.departamento,
      this.provincia,
      this.distrito,
      this.telefono,
      this.email,
      this.costoEnvio});

  factory OrderQuery.fromJson(Map<String, dynamic> json) {
    return OrderQuery(
        id: int.parse(json['ID_PEDIDO']),
        fecha: json['FECHA_PEDIDO'],
        metodoPago: json['DESCRIPCION_METODO'],
        metodoEnvio: json['METODO'],
        estadoPedido: json['DESCRIPCION_ESTADO'],
        nombre: json['NOMBRE'],
        apellido: json['APELLIDO'],
        total: double.parse(json['TOTAL']),
        direccion: json['DIRECCION'],
        departamento: json['DEPARTAMENTO_NOMBRE'],
        provincia: json['PROVINCIA_NOMBRE'],
        distrito: json['DISTRITO_NOMBRE'],
        telefono: json['TELEFONO'],
        email: json['EMAIL'],
        costoEnvio: double.parse(json['COSTO']));
  }
}

Future<List<OrderQuery>> fetchPostOQS() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/orderQuery.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => OrderQuery.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
