
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/recipe_service.dart';

class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Caderno'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: recipeService.getSavedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar suas receitas. '
                  'Verifique sua conexão e as regras do Firestore.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 76,
                      color: Color(0xFF52734D),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Seu caderno está vazio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pesquise uma receita e salve-a para '
                      'encontrá-la aqui depois.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final recipe = document.data();

              final name =
                  (recipe['name'] ?? 'Receita sem nome').toString();
              final imageUrl =
                  (recipe['imageUrl'] ?? '').toString();
              final category =
                  (recipe['category'] ?? 'Sem categoria').toString();

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 76,
                                height: 76,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(
                                  width: 76,
                                  height: 76,
                                  child: Icon(Icons.restaurant, size: 36),
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 76,
                              height: 76,
                              child: Icon(Icons.restaurant, size: 36),
                            ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(category),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SavedRecipeDetailScreen(
                                      recipe: recipe,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.visibility_outlined),
                              label: const Text('Ver receita'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            tooltip: 'Excluir receita',
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Excluir receita?'),
                                  content: Text(
                                    'Deseja remover "$name" do seu caderno?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                        dialogContext,
                                        false,
                                      ),
                                      child: const Text('Cancelar'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(
                                        dialogContext,
                                        true,
                                      ),
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed != true) return;

                              try {
                                await recipeService.deleteRecipe(document.id);

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Receita excluída.'),
                                  ),
                                );
                              } catch (_) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Não foi possível excluir a receita.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SavedRecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const SavedRecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final name = (recipe['name'] ?? 'Receita').toString();
    final imageUrl = (recipe['imageUrl'] ?? '').toString();
    final category = (recipe['category'] ?? 'Sem categoria').toString();
    final instructions =
        (recipe['instructions'] ?? 'Instruções indisponíveis').toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da receita'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
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
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F3D2C),
                  ),
                ),
                const SizedBox(height: 8),
                Chip(label: Text(category)),
                const SizedBox(height: 24),
                const Text(
                  'Modo de preparo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  instructions,
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
