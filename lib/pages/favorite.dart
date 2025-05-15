import 'package:flutter/material.dart';
import 'package:movienest/pages/data_base.dart';
import '../models/movie.dart';


class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritePage> {
  late Future<List<Movie>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = DBService.getFavorites() as Future<List<Movie>>;
  }

  void _refreshFavorites() {
    setState(() {
      favoritesFuture = DBService.getFavorites() as Future<List<Movie>>;
    });
  }

  void _confirmDelete(Movie movie) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmation"),
        content: Text("Supprimer '${movie.title}' des favoris ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              await DBService.removeFavorite(movie.id);
              Navigator.of(ctx).pop();
              _refreshFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Film supprimé des favoris"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF330f3d),
      appBar: AppBar(
        title: const Text("Mes Favoris" ,style: TextStyle(color: Color(0xFFC68EFD)),),
        backgroundColor: const Color(0xFF330f3d),
      ),
      body: FutureBuilder<List<Movie>>(
        future: favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Aucun film en favori.",
                  style: TextStyle(color: Colors.white)),
            );
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return Dismissible(
                  key: Key(movie.id.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    _confirmDelete(movie);
                    return false;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: const Color(0xFF1C1C1C),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w154${movie.posterPath}',
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.releaseDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.overview,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}