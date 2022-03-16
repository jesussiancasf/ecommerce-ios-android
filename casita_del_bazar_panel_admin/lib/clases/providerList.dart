import 'package:http/http.dart' as http;
import 'dart:convert';

class ProveedorLista {
  final int id;
  final String nombre;
  final String apellido;
  final String empresa;
  final String imagen;

  ProveedorLista(
      {this.id, this.nombre, this.apellido, this.empresa, this.imagen});
  factory ProveedorLista.fromJson(Map<String, dynamic> json) {
    return ProveedorLista(
        id: int.parse(json['ID_PROVEEDOR']),
        nombre: json['NOMBRE_PROVEEDOR'],
        apellido: json['APELLIDO_PROVEEDOR'],
        empresa: json['EMPRESA'],
        imagen: json['IMAGEN']);
  }
}

Future<List<ProveedorLista>> fetchPostPL() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/listProvider.php'));
  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => ProveedorLista.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
