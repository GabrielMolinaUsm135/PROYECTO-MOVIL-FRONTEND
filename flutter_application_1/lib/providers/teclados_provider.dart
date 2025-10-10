import 'dart:convert';
import 'package:http/http.dart' as http;

class TecladosProvider {
  final apiUrl = 'http://192.168.1.101:3000/api/teclados';

  Future<List<dynamic>> getTeclados() async {
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['teclados'];
    } else {
      return [];
    }
  }
}