import 'package:flutter/material.dart';
import 'package:movienest/services/data_base.dart';
import '../models/movie.dart';
import 'moviesDetails.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoriteWatchlistPageState();
}

class _FavoriteWatchlistPageState extends State<FavoritePage> {
  late Future<List<Movie>> favoritesFuture;
  late Future<List<Movie>> watchlistFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    favoritesFuture = DBService.getFavorites();
    watchlistFuture = DBService.getWatchlist();
  }

  void _refreshData() {
    setState(() {
      _loadData();
    });
  }

  void _confirmDeleteFavorite(Movie movie) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2D),
            title: const Text("Confirmation", style: TextStyle(color: Colors.white)),
            content: Text("Supprimer '${movie.title}' des favoris ?",
                style: const TextStyle(color: Colors.white70)),
            actions: [
            TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
    child: const Text("Annuler", style: TextStyle(color: Color(0xFFC68EFD)))),
    TextButton(
    onPressed: () async {
    await DBService.removeFavorite(movie.id);
    Navigator.of(ctx).pop();
    _refreshData();
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: const Text("Film supprimé des favoris"),
    backgroundColor: const Color(0xFFE50914),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    );
    },
    child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
    ),
            ],
    ),
    );
  }

  void _confirmDeleteWatchlist(Movie movie) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2D),
        title: const Text("Confirmation", style: TextStyle(color: Colors.white)),
        content: Text("Supprimer '${movie.title}' de la watchlist ?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Annuler", style: TextStyle(color: Color(0xFFC68EFD))),
          ),
          TextButton(
            onPressed: () async {
              await DBService.removeFromWatchlist(movie.id);
              Navigator.of(ctx).pop();
              _refreshData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Film supprimé de la watchlist"),
                  backgroundColor: const Color(0xFFE50914),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie, Function(Movie) onDelete) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF1E1E2D),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>MoviesDetails(movie: movie)));
        },
        child: Dismissible(
          key: Key(movie.id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            onDelete(movie);
            return false;
          },
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red[800],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w154${movie.posterPath}',
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, color: Colors.white24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            movie.releaseDate,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Future<List<Movie>> future,
    required Function(Movie) onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC68EFD)),
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "Aucun film dans $title",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              );
            } else {
              return Column(
                children: snapshot.data!
                    .map((movie) => _buildMovieCard(movie, onDelete))
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1B),
      appBar: AppBar(
        title: const Text(
          "Mes Favoris & Watchlist",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF330F3D).withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: const Color(0xFF330F3D),
        color: const Color(0xFFC68EFD),
        onRefresh: () async {
          _refreshData();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildSection(
                title: "Mes Favoris",
                future: favoritesFuture,
                onDelete: _confirmDeleteFavorite,
              ),
              _buildSection(
                title: "Ma Watchlist",
                future: watchlistFuture,
                onDelete: _confirmDeleteWatchlist,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}