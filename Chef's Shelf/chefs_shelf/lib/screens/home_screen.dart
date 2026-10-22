
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/auth_service.dart';
import '../services/meal_api_service.dart';
import 'meal_detail_screen.dart';
import 'my_recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _apiService = MealApiService();

  List<Meal> _meals = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMeals([String? value]) async {
    final query = (value ?? _searchController.text).trim();

    if (query.isEmpty) {
      setState(() {
        _meals = [];
        _searched = false;
        _error = null;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _searched = true;
      _error = null;
    });

    try {
      final results = await _apiService.searchMeals(query);

      if (!mounted) return;

      setState(() => _meals = results);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _meals = [];
        _error = 'Não foi possível carregar as receitas. Verifique a conexão e tente novamente.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService().logout();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível sair da conta.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chef's Shelf"),
          actions: [
            IconButton(
               tooltip: 'Meu Caderno',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (_) => const MyRecipesScreen(),
                   ),
                );
              },
    icon: const Icon(Icons.menu_book_outlined),
  ),
  IconButton(
    tooltip: 'Sair da conta',
    onPressed: _logout,
    icon: const Icon(Icons.logout),
  ),
],

      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Encontre sua próxima receita',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3D2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pesquise pratos e descubra como prepará-los.',
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _searchMeals,
                    decoration: InputDecoration(
                      hintText: 'Ex.: chicken, pasta, curry...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: 'Pesquisar',
                        onPressed: () => _searchMeals(),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _searchMeals(),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_searched && _meals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhuma receita encontrada. Tente pesquisar outro nome em inglês.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!_searched) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 72,
                color: Color(0xFF52734D),
              ),
              SizedBox(height: 16),
              Text(
                'Seu próximo prato começa aqui.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Digite o nome de uma receita para começar.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final meal = _meals[index];

        return Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(meal: meal),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal.imageUrl.isNotEmpty)
                  Image.network(
                    meal.imageUrl,
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 150,
                      child: Icon(Icons.restaurant, size: 48),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('${meal.category} • ${meal.area}'),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Ver receita',
                            style: TextStyle(
                              color: Color(0xFF52734D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Color(0xFF52734D),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
