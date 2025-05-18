class Movie {
  int id;
  String title;
  String backDropPath;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  String? originalLanguage;
  double? popularity;
  List<String>? genres;      // nouveau champ
  int? runtime;              // nouveau champ

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    this.originalLanguage,
    this.popularity,
    this.genres,
    this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String>? genreNames;
    if (json['genres'] != null && json['genres'] is List) {
      genreNames = List<String>.from(
        (json['genres'] as List)
            .map((genre) => genre['name'].toString())
            .toList(),
      );
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Titre non disponible',
      backDropPath: json['backdrop_path'] ?? 'Pas de backDropPath',
      overview: json['overview'] ?? 'Pas d\'overview',
      posterPath: json['poster_path'] ?? 'Pas de posterPath',
      releaseDate: json['release_date'] ?? 'Date non disponible',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      originalLanguage: json['original_language'],
      popularity: (json['popularity'] ?? 0).toDouble(),
      genres: genreNames,
      runtime: json['runtime'], // peut être null
    );
  }

  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      backDropPath: map['backdrop_path'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      releaseDate: map['release_date'],
      voteAverage: map['vote_average'],
      originalLanguage: map['original_language'],
      popularity: map['popularity'],
      genres: map['genres'] != null ? List<String>.from(map['genres']) : null,
      runtime: map['runtime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'backdrop_path': backDropPath,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'original_language': originalLanguage,
      'popularity': popularity,
      'genres': genres,
      'runtime': runtime,
    };
  }
}
