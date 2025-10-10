import 'dart:convert';

import 'package:http/http.dart' as http;

class TecladosProvider {
  final apiUrl = 'http://localhost:3000/api/teclados';

  Future<List<dynamic>> getTeclados() async {
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}