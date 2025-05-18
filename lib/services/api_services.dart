import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constante.dart';
import '../models/movie.dart';
import '../models/actor.dart';
import '../models/video.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  final String apiKey = '17a4746d1279d59acedb39a23898a3ea';
  final String baseUrl = 'https://api.themoviedb.org/3';
  static const _mouviesUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constante.apiKey}';
  static const _TrendingUrl =
      'https://api.themoviedb.org/3/movie/popular?api_key=${Constante.apiKey}';
  static const _RatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constante.apiKey}';
  static const _UpcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constante.apiKey}';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '17a4746d1279d59acedb39a23898a3ea';

  Future<List<Movie>> getNowMovies() async{
    try{
      final response = await http.get(Uri.parse(_mouviesUrl));
      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load data');
      }
    }catch(e){
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<List<Movie>> getTrendingMovies() async{
    try{
      final response = await http.get(Uri.parse(_TrendingUrl));
      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load data');
      }
    }catch(e){
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<List<Movie>> getRatedMovies() async{
    try{
      final response = await http.get(Uri.parse(_RatedUrl));
      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load data');
      }
    }catch(e){
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async{
    try{
      final response = await http.get(Uri.parse(_UpcomingUrl));
      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load data');
      }
    }catch(e){
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<List<Actor>> getCast(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey&language=fr'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List castList = data['cast'];
      return castList.map((json) => Actor.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des acteurs');
    }
  }

  Future<Actor> getActorDetails(int actorId) async {
    final response = await http.get(Uri.parse('$baseUrl/person/$actorId?api_key=$apiKey&language=fr'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Actor.fromJson(data);
    } else {
      throw Exception('Échec du chargement des détails de l\'acteur');
    }
  }

  Future<List<Actor>> getPopularActors() async {
    final response = await http.get(Uri.parse('$baseUrl/person/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];
      return results.map((actorJson) => Actor.fromJson(actorJson)).toList();
    } else {
      throw Exception('Failed to load popular actors');
    }
  }

  Future<List<Movie>> getActorMovies(int actorId) async {
    final response = await http.get(Uri.parse('$baseUrl/person/$actorId/movie_credits?api_key=$apiKey&language=fr'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List castList = data['cast'];
      return castList.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des films de l\'acteur');
    }
  }

  Future<Video?> getTrailer(int movieId) async {
    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey')
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];

      if (results != null && results.isNotEmpty) {
        final trailer = results.firstWhere(
              (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );

        if (trailer != null) {
          return Video.fromJson(trailer);
        }
      }
    }

    return null;
  }



  /// Fonction statique pour retourner l'URL complète d'une bande-annonce YouTube
  static Future<String?> fetchTrailerUrl(int movieId) async {
    final api = ApiService();
    try {
      final video = await api.getTrailer(movieId);
      if (video != null && video.site.toLowerCase() == 'youtube') {
        return 'https://www.youtube.com/watch?v=${video.key}';
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération du trailer: $e');
    }
    return null;
  }



}
