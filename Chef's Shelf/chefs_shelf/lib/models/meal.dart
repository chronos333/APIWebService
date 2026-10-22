
class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (var i = 1; i <= 20; i++) {
      final ingredient =
          (json['strIngredient$i'] ?? '').toString().trim();
      final measure =
          (json['strMeasure$i'] ?? '').toString().trim();

      if (ingredient.isNotEmpty) {
        ingredients.add(
          measure.isEmpty ? ingredient : '$measure $ingredient',
        );
      }
    }

    return Meal(
      id: (json['idMeal'] ?? '').toString(),
      name: (json['strMeal'] ?? 'Receita sem nome').toString(),
      imageUrl: (json['strMealThumb'] ?? '').toString(),
      category: (json['strCategory'] ?? 'Sem categoria').toString(),
      area: (json['strArea'] ?? 'Não informada').toString(),
      instructions:
          (json['strInstructions'] ?? 'Instruções indisponíveis').toString(),
      ingredients: ingredients,
    );
  }
}