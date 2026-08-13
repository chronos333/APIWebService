import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000"; //URL da API
  //obs: declaração de atributos e métodos usa-se lowerCamelCase
  //obs: declaração de classes usa-se UpperCamelCase

  // método de classe para acessar os endpoints da api
  // GET(ALL)
  static Future<List<dynamic>> getList(String path) async {
    //no dart precisa converter String => URL (Uri.parse)
    final res = await http.get(Uri.parse("$baseUrl/$path"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    //criando um erro para ser tratado no futuro
    throw Exception("Falha de conexão com a api $path");
  }

  // GET(One)
  static Future<Map<String, dynamic>> getOne(String path, String id) async {
    final res = await http.get(Uri.parse("$baseUrl/$path/$id")); //request
    if (res.statusCode == 200) {
      //response
      return jsonDecode(res.body);
    }
    throw Exception("Falha de conexão com a api $path");
  }

  // POST
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/$path"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 201) return jsonDecode(res.body);
    throw Exception("Falha de conexão com a api $path");
  }

  // PUT
  static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
    String id,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/$path/$id"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Falha de conexão com a api $path");
  }

  // DELETE
  static Future<void> delete(String path, String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$path/$id"));
    if (res.statusCode != 200) throw Exception("Falaha ao deletar de $path");
  }
}
