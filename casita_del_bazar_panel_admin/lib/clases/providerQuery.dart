import 'package:http/http.dart' as http;
import 'dart:convert';

class ProviderQuery {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String direccion;
  final String empresa;
  final String imagen;
  final String departamento;
  final String provincia;
  final String distrito;

  ProviderQuery(
      {this.id,
      this.nombre,
      this.apellido,
      this.email,
      this.telefono,
      this.direccion,
      this.empresa,
      this.imagen,
      this.departamento,
      this.provincia,
      this.distrito});

  factory ProviderQuery.fromJson(Map<String, dynamic> json) {
    return ProviderQuery(
      id: int.parse(json['ID_PROVEEDOR']),
      nombre: json['NOMBRE_PROVEEDOR'],
      apellido: json['APELLIDO_PROVEEDOR'],
      email: json['EMAIL_PROVEEDOR'],
      telefono: json['TELEFONO_PROVEEDOR'],
      direccion: json['DIRECCION'],
      empresa: json['EMPRESA'],
      imagen: json['IMAGEN'],
      departamento: json['DEPARTAMENTO_NOMBRE'],
      provincia: json['PROVINCIA_NOMBRE'],
      distrito: json['DISTRITO_NOMBRE'],
    );
  }
}

Future<List<ProviderQuery>> fetchPostPVQ() async {
  final response = await http
      .get(Uri.parse('http://18.228.156.121/casita/listar/providerQuery.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList.map((element) => ProviderQuery.fromJson(element)).toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
