
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealApiService {
  static const String _baseUrl =
      'www.themealdb.com';

  Future<List<Meal>> searchMeals(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.https(
      _baseUrl,
      '/api/json/v1/1/search.php',
      {'s': trimmedQuery},
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode != 200) {
      throw Exception('Não foi possível carregar as receitas.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'];

    if (meals == null) {
      return [];
    }

    return (meals as List)
        .map((item) => Meal.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
