import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/data/models/all_models.dart';

const String tmdbImagesBaseUrl = 'https://image.tmdb.org/t/p/original';

class Content {
  final String imageUrl;
  final String titleImageUrl;
  final String videoUrl;
  final String description;
  final Color color;

  final int id;
  final String name;
  final bool adult;
  final int voteCount;
  final double voteAverage;

  // String releaseDate;
  final String year;

  // String originalLanguage;
  final String backdropPath;
  final String overview;
  final String posterPath;
  final String mediaType;

  // final List<int> genreIds;

  final Collection collection;

  int budget;
  Genre genresList;
  String homepage;
  String imdbId;
  int revenue;
  int runtime;
  String status;
  String tagLine;
  List<Cast> cast;

  Season season;

  Content({
    this.id,
    this.name,
    this.adult,
    this.voteCount,
    this.voteAverage,
    this.year,
    this.backdropPath,
    this.overview,
    this.posterPath,
    this.mediaType,
    this.collection,
    this.imageUrl,
    this.titleImageUrl,
    this.videoUrl,
    this.color,
    this.description = 'No description',
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    final isMovie = json['media_type'] == 'movie';

    return Content(
      id: json['id'] as int,
      name: isMovie ? json['title'] as String : json['name'] as String,
      posterPath: (json['poster_path'] != null)
          ? tmdbImagesBaseUrl + (json['poster_path'] as String)
          : null,
    );
  }
}
