class Video {
  final String key;
  final String name;
  final String site;
  final String type;

  Video({
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      key: json['key'],
      name: json['name'],
      site: json['site'],
      type: json['type'],
    );
  }
}
