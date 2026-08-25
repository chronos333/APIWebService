import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class TmdbService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String apiKey = '4ff4f1094da2c873b81e91412fa553c1';

  // =====================================================
  // BUSCAR FILMES
  // =====================================================

  static Future<List<Movie>> buscarFilmes(String query) async {
    try {
      final uri = Uri.parse('$baseUrl/search/movie').replace(
        queryParameters: {
          'api_key': apiKey,
          'query': query,
          'language': 'pt-BR',
          'page': '1',
        },
      );

      final response = await http.get(uri);

      print('Busca status: ${response.statusCode}');

      print('Busca resposta: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Erro da API: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final List resultados = data['results'] ?? [];

      return resultados
          .map((item) => Movie.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('ERRO TMDB BUSCA: $e');

      throw Exception('Não foi possível buscar os filmes: $e');
    }
  }

  // =====================================================
  // BUSCAR DETALHES DE UM FILME
  // =====================================================

  static Future<Map<String, dynamic>> buscarDetalhes(int id) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/movie/$id',
      ).replace(queryParameters: {'api_key': apiKey, 'language': 'pt-BR'});

      final response = await http.get(uri);

      print('Detalhes status: ${response.statusCode}');

      print('Detalhes resposta: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Erro da API: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data;
    } catch (e) {
      print('ERRO TMDB DETALHES: $e');

      throw Exception('Não foi possível carregar os detalhes: $e');
    }
  }
}
