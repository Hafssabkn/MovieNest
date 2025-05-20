import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movienest/constante.dart';
import 'dart:convert';
import '../models/movie.dart';
import 'moviesDetails.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCategory = 'Action';
  String searchQuery = '';
  List<Movie> movies = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  final Map<String, int> categoryMap = {
    'Action': 28,
    'Comédie': 35,
    'Drame': 18,
    'Horreur': 27,
    'Science-Fiction': 878,
    'Animation': 16,
    'Aventure': 12,
    'Fantastique': 14,
    'Romance': 10749,
    'Thriller': 53,
  };

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMovies() async {
    setState(() => isLoading = true);
    final genreId = categoryMap[selectedCategory];
    final url =
        'https://api.themoviedb.org/3/discover/movie?api_key=${Constante.apiKey}&with_genres=$genreId&language=fr';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        setState(() {
          movies = results.map((json) => Movie.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _showError('Erreur de chargement des films');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Erreur de connexion');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Movie> get filteredMovies {
    if (searchQuery.isEmpty) return movies;
    return movies
        .where((movie) =>
        movie.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF330f3d),
        body: SafeArea(
          child: Column(
              children: [
          // Search Bar
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Rechercher un film...',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ),

       // Catego horizontal
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: categoryMap.keys.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category,
                      style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black)),
                  selected: selectedCategory == category,
                  selectedColor: const Color(0xFF330f3d).withOpacity(0.6),
                  backgroundColor: Colors.white.withOpacity(0.1),
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                      fetchMovies();
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Results
        Expanded(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
            )
          ): filteredMovies.isEmpty
          ? const Center(
          child: Text(
            'Aucun résultat trouvé',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        )
            : GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    ),
    itemCount: filteredMovies.length,
    itemBuilder: (context, index) {
    final movie = filteredMovies[index];
    return _buildMovieCard(movie);
    },
    ),
    ),
    ],
    ),
    ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>MoviesDetails(movie: movie)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Movie Poster
            movie.posterPath != null
                ? Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.movie, color: Colors.white24),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    color: const Color(0xFFE50914),
                  ),
                );
              },
            )
                : Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.movie, color: Colors.white24),
              ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Movie Info
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        movie.releaseDate?.substring(0, 4) ?? '',
                        style: const TextStyle(color: Colors.white70),
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
  }
}