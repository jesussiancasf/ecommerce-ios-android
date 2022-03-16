import 'package:http/http.dart' as http;
import 'dart:convert';

class GuiasRLista {
  final String idGuia;
  final String fecha;
  final String proveedor;

  GuiasRLista({this.idGuia, this.fecha, this.proveedor});
  factory GuiasRLista.fromJson(Map<String, dynamic> json) {
    return GuiasRLista(
      idGuia: json["NUM_GUIA"],
      fecha: json['FECHA'],
      proveedor: json['EMPRESA'],
    );
  }
}

Future<List<GuiasRLista>> fetchPostGRL() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listRGuide.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => GuiasRLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
