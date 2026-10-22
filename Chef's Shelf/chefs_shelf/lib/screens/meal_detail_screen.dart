
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/recipe_service.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({
    super.key,
    required this.meal,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _recipeService = RecipeService();

  bool _loading = false;
  bool _saved = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    try {
      final saved = await _recipeService.isRecipeSaved(widget.meal.id);

      if (mounted) {
        setState(() {
          _saved = saved;
          _checking = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _toggleSaved() async {
    setState(() => _loading = true);

    try {
      if (_saved) {
        await _recipeService.deleteRecipe(widget.meal.id);

        if (mounted) {
          setState(() => _saved = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita removida do caderno.')),
          );
        }
      } else {
        await _recipeService.saveRecipe(
          id: widget.meal.id,
          name: widget.meal.name,
          imageUrl: widget.meal.imageUrl,
          category: widget.meal.category,
          instructions: widget.meal.instructions,
        );

        if (mounted) {
          setState(() => _saved = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita salva no caderno!')),
          );
        }
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no Firestore: ${error.message ?? error.code}')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar a receita: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da receita'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          if (meal.imageUrl.isNotEmpty)
            Image.network(
              meal.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 180,
                child: Icon(Icons.restaurant, size: 64),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F3D2C),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(meal.category)),
                    Chip(label: Text(meal.area)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading || _checking ? null : _toggleSaved,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _saved ? Icons.bookmark_remove : Icons.bookmark_add,
                          ),
                    label: Text(
                      _saved ? 'Remover do Meu Caderno' : 'Salvar no Meu Caderno',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF52734D),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Ingredientes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (meal.ingredients.isEmpty)
                  const Text('Ingredientes não disponíveis.')
                else
                  ...meal.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF52734D),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(ingredient)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Modo de preparo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  meal.instructions.replaceAll('\r\n', '\n').trim(),
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
