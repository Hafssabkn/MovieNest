import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movienest/constante.dart';
import 'dart:convert';

import '../models/Movie.dart';

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

  final Map<String, int> categoryMap = {
    'Action': 28,
    'Comedy': 35,
    'Drama': 18,
    'Horror': 27,
    'Science Fiction': 878,
    'Animation': 16,
  };

  final String apiKey = Constante.apiKey;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() => isLoading = true);
    final genreId = categoryMap[selectedCategory];
    final url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId&language=fr';

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
    }
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
      backgroundColor: Color(0xFF330f3d),
      appBar: AppBar(
        backgroundColor: Color(0xFF330f3d),
        title: const Text('Catégories de films',style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  fetchMovies();
                });
              },
              items: categoryMap.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category,style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Rechercher un film...',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: ListView.builder(
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];
                  return ListTile(
                    leading: movie.posterPath != null
                        ? Image.network(
                      'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.movie),
                    title: Text(movie.title,style: TextStyle(color: Colors.white)),
                    subtitle: Text(movie.releaseDate ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
