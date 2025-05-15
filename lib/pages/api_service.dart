import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movienest/constante.dart';
import 'package:movienest/models/Movie.dart';

class ApiService {
  static const _mouviesUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constante.apiKey}';
  static const _TrendingUrl =
      'https://api.themoviedb.org/3/movie/popular?api_key=${Constante.apiKey}';
  static const _RatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constante.apiKey}';
  static const _UpcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constante.apiKey}';


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
}
