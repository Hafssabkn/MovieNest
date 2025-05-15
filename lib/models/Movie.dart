class Movie {
  int id;
  String title;
  String backDropPath;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;


  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Titre non disponible',
      backDropPath: json['backdrop_path'] ?? 'Pas de backDropPath',
      overview: json['overview'] ?? 'Pas d\'overview',
      posterPath: json['poster_path'] ?? 'Pas de posterPath',
      releaseDate: json['release_date'] ?? 'Date non disponible',
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title': title,
      'backdrop_path': backDropPath,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
    };
  }
}
