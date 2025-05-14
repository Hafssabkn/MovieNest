class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'release_date': releaseDate,
    };
  }
}
