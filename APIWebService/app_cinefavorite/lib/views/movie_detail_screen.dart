import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/database_service.dart';
import '../services/tmdb_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Map<String, dynamic>? detalhes;

  bool carregando = true;

  @override
  void initState() {
    super.initState();

    carregarDetalhes();
  }

  // =====================================================
  // BUSCAR DETALHES
  // =====================================================

  Future<void> carregarDetalhes() async {
    try {
      final resultado = await TmdbService.buscarDetalhes(widget.movie.id);

      if (!mounted) return;

      setState(() {
        detalhes = resultado;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar detalhes: $e');

      if (!mounted) return;

      setState(() {
        carregando = false;
      });
    }
  }

  // =====================================================
  // ADICIONAR FAVORITO
  // =====================================================

  Future<void> adicionarFavorito() async {
    try {
      await DatabaseService.addFavoriteMovie(widget.movie);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Filme adicionado aos favoritos ')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao adicionar favorito: $e')));
    }
  }

  // =====================================================
  // INTERFACE
  // =====================================================

  @override
  Widget build(BuildContext context) {
    // ===================================================
    // CARREGANDO
    // ===================================================

    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ===================================================
    // ERRO
    // ===================================================

    if (detalhes == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Não foi possível carregar '
              'os detalhes do filme.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    // ===================================================
    // DADOS DO FILME
    // ===================================================

    final overview = detalhes!['overview'] ?? 'Sem sinopse disponível.';

    final releaseDate = detalhes!['release_date'] ?? 'Não informado';

    final voteAverage = detalhes!['vote_average'] != null
        ? (detalhes!['vote_average'] as num).toDouble()
        : 0.0;

    // ===================================================
    // TELA
    // ===================================================

    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ===========================================
            // POSTER
            // ===========================================
            if (widget.movie.posterPath != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',

                    height: 400,

                    fit: BoxFit.cover,

                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const SizedBox(
                        height: 400,

                        child: Center(child: CircularProgressIndicator()),
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 400,

                        child: Center(
                          child: Icon(Icons.broken_image, size: 80),
                        ),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ===========================================
            // TÍTULO
            // ===========================================
            Text(
              widget.movie.title,

              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ===========================================
            // NOTA
            // ===========================================
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),

                const SizedBox(width: 5),

                Text(
                  voteAverage.toStringAsFixed(1),

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(' / 10', style: TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 8),

            // ===========================================
            // LANÇAMENTO
            // ===========================================
            Text(
              'Lançamento: $releaseDate',

              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 25),

            // ===========================================
            // SINOPSE
            // ===========================================
            const Text(
              'Sinopse',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(overview, style: const TextStyle(fontSize: 16, height: 1.5)),

            const SizedBox(height: 25),

            // ===========================================
            // FAVORITO
            // ===========================================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: adicionarFavorito,

                icon: const Icon(Icons.favorite_border),

                label: const Text('Adicionar aos favoritos'),

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
