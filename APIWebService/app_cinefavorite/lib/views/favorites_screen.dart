import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/database_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Movie> filmes = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarFavoritos();
  }

  Future<void> carregarFavoritos() async {
    final resultado = await DatabaseService.getFavoriteMovies();

    setState(() {
      filmes = resultado;
      carregando = false;
    });
  }

  Future<void> remover(Movie movie) async {
    await DatabaseService.deleteFavoriteMovie(movie.id);

    await carregarFavoritos();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filme removido dos favoritos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filmes.isEmpty) {
      return const Center(child: Text('Você ainda não possui favoritos '));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),

      itemCount: filmes.length,

      itemBuilder: (context, index) {
        final movie = filmes[index];

        return Card(
          clipBehavior: Clip.antiAlias,

          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: movie.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.movie, size: 60),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => remover(movie),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
