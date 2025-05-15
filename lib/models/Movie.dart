class Movie {
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;


  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Titre non disponible',
      backDropPath: json['backdrop_path'] ?? 'Pas de backDropPath',
      originalTitle: json['original_title'] ?? 'Titre original non disponible',
      overview: json['overview'] ?? 'Pas d\'overview',
      posterPath: json['poster_path'] ?? 'Pas de posterPath',
      releaseDate: json['release_date'] ?? 'Date non disponible',
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backdrop_path': backDropPath,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
    };
  }
}
