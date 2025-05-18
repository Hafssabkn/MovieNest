import 'package:flutter/material.dart';

class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final String biography;

  Actor({
    required this.id,
    required this.name,
    this.profilePath,
    required this.biography,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      biography: json['biography'],
    );
  }
}
