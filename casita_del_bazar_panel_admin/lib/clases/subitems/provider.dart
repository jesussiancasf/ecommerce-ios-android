import 'package:http/http.dart' as http;
import 'dart:convert';

class ProvidersWidget {
  final int id;
  final String empresa;

  ProvidersWidget({this.id, this.empresa});
  factory ProvidersWidget.fromJson(Map<String, dynamic> json) {
    return ProvidersWidget(
      id: int.parse(json['ID_PROVEEDOR']),
      empresa: json['EMPRESA'],
    );
  }
}

Future<List<ProvidersWidget>> fetchPostPW() async {
  final response = await http.get(
      Uri.parse('http://18.228.156.121/casita/listar/subitems/providers.php'));

  if (response.statusCode == 200) {
    var jsonList = json.decode(response.body) as List;
    return jsonList
        .map((element) => ProvidersWidget.fromJson(element))
        .toList();
  } else {
    throw Exception('Falló la solicitud');
  }
}
