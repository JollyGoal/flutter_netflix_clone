import 'all_models.dart';

class Collection {
  final int id;
  final String name;
  final String posterPath;
  final String backdropPath;

  const Collection({
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as int,
      name: json['name'] as String,
      posterPath: (json['poster_path'] != null)
          ? tmdbImagesBaseUrl + (json['poster_path'] as String)
          : null,
      backdropPath: (json['backdrop_path'] != null)
          ? tmdbImagesBaseUrl + (json['backdrop_path'] as String)
          : null,
    );
  }
}
