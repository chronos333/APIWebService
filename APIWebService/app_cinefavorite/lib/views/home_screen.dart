import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/tmdb_service.dart';
import 'favorites_screen.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Movie> filmes = [];

  bool carregando = false;

  String? erro;

  int paginaAtual = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =========================
  // BUSCAR FILMES
  // =========================

  Future<void> pesquisar() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        erro = 'Digite o nome de um filme.';
        filmes = [];
      });

      return;
    }

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await TmdbService.buscarFilmes(query);

      setState(() {
        filmes = resultado;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao buscar filmes.';
        filmes = [];
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  // =========================
  // TELA DE BUSCA
  // =========================

  Widget buildSearchPage() {
    return Column(
      children: [
        // BARRA DE PESQUISA
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,

                  onSubmitted: (_) {
                    pesquisar();
                  },

                  decoration: InputDecoration(
                    hintText: 'Buscar filme...',

                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchController.clear();

                                filmes = [];
                                erro = null;
                              });
                            },
                          )
                        : null,

                    border: const OutlineInputBorder(),

                    filled: true,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              ElevatedButton(
                onPressed: carregando ? null : pesquisar,

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                ),

                child: const Icon(Icons.search),
              ),
            ],
          ),
        ),

        // CONTEÚDO
        Expanded(child: buildSearchContent()),
      ],
    );
  }

  // =========================
  // CONTEÚDO DA BUSCA
  // =========================

  Widget buildSearchContent() {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.error_outline, size: 60),

              const SizedBox(height: 15),

              Text(
                erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: pesquisar,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (filmes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.movie_outlined, size: 80),

            SizedBox(height: 15),

            Text(
              'Pesquise por um filme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            Text(
              'Digite o nome de um filme acima.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        crossAxisSpacing: 10,

        mainAxisSpacing: 10,

        childAspectRatio: 0.62,
      ),

      itemCount: filmes.length,

      itemBuilder: (context, index) {
        final filme = filmes[index];

        return buildMovieCard(filme);
      },
    );
  }

  // =========================
  // CARD DO FILME
  // =========================

  Widget buildMovieCard(Movie filme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: filme),
          ),
        );
      },

      child: Card(
        clipBehavior: Clip.antiAlias,

        elevation: 3,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // POSTER
            Expanded(
              child: filme.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${filme.posterPath}',

                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(child: CircularProgressIndicator());
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    )
                  : const Center(child: Icon(Icons.movie, size: 60)),
            ),

            // TÍTULO
            Padding(
              padding: const EdgeInsets.all(8),

              child: Text(
                filme.title,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                textAlign: TextAlign.center,

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CineFavorite'), centerTitle: true),

      body: IndexedStack(
        index: paginaAtual,

        children: [buildSearchPage(), const FavoritesScreen()],
      ),

      // =========================
      // MENU INFERIOR
      // =========================
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,

        onDestinationSelected: (index) {
          setState(() {
            paginaAtual = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),

            selectedIcon: Icon(Icons.search),

            label: 'Buscar',
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite_border),

            selectedIcon: Icon(Icons.favorite),

            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
