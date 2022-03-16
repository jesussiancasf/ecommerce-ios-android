import 'package:http/http.dart' as http;
import 'dart:convert';

class BuyQuery {
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String empresa;
  final int id;
  final String fecha;
  final double total;
  final String comprobante;
  final String tipoComprobante;
  final String imagen;

  BuyQuery({
    this.nombre,
    this.apellido,
    this.telefono,
    this.email,
    this.empresa,
    this.id,
    this.fecha,
    this.total,
    this.comprobante,
    this.tipoComprobante,
    this.imagen,
  });

  factory BuyQuery.fromJson(Map<String, dynamic> json) {
    return BuyQuery(
      nombre: json['NOMBRE_PROVEEDOR'],
      apellido: json['APELLIDO_PROVEEDOR'],
      telefono: json['TELEFONO_PROVEEDOR'],
      email: json['EMAIL_PROVEEDOR'],
      empresa: json['EMPRESA'],
      id: int.parse(json['ID_COMPRA']),
      fecha: json['FECHA_COMPRA'],
      total: double.parse(json['MONTO']),
      comprobante: json['NUMERO_COMPROBANTE'],
      tipoComprobante: json['DETALLE_COMPROBANTE'],
      imagen: json['IMAGEN_COMPROBANTE'],
    );
  }
}

Future<List<BuyQuery>> fetchPostBQS() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/buyQuery.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => BuyQuery.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
