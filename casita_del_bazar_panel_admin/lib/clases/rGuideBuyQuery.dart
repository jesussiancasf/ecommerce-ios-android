import 'package:http/http.dart' as http;
import 'dart:convert';

class GuiasRemisionList {
  final String numero;
  final String descripcion;
  final String fecha;
  final String imagen;

  GuiasRemisionList({
    this.numero,
    this.descripcion,
    this.fecha,
    this.imagen,
  });
  factory GuiasRemisionList.fromJson(Map<String, dynamic> json) {
    return GuiasRemisionList(
      numero: json['NUM_GUIA'],
      descripcion: json['DESCRIPCION'],
      fecha: json['FECHA'],
      imagen: json['IMAGEN'],
    );
  }
}

Future<List<GuiasRemisionList>> fetchPostGRQL(String idCompra) async {
  final response = await http.post(
      Uri.parse("http://18.228.156.121/casita/listar/rGuideQuery.php"),
      body: {"idCompra": idCompra});

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => GuiasRemisionList.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
