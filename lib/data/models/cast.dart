import 'package:flutter_netflix_responsive/config/constants.dart';
import 'package:meta/meta.dart';

class Cast {
  final int id;
  final String character;
  final String name;
  final String profilePath;

  const Cast({
    @required this.id,
    this.character,
    this.name,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] as int,
      name: json['name'] as String,
      character: json['character'] as String,
      profilePath: (json['profile_path'] != null)
        ? tmdbImagesBaseUrl + (json['profile_path'])
        : null,
    );
  }
}
