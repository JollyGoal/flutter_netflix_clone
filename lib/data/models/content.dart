import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/config/constants.dart';
import 'package:flutter_netflix_responsive/data/models/models.dart';

class Content {
  final Color color;
  final String titleImageUrl;
  final String videoUrl;

  final int id;
  final String name;
  final bool adult;
  final String releaseDate;
  final int runtime;
  final String overview;
  final String tagLine;
  final String posterPath;
  final String backdropPath;
  final String mediaType;
  final List<Genre> genresList;
  final List<Cast> castList;
  final List<Video> videos;
  final List<String> backdropsList;
  final List<String> postersList;
  final Collection collection;
  final int voteCount;
  final double voteAverage;
  final int budget;
  final int revenue;
  final String status;
  final String homepage;

  final String imdbId;
  final Season season;

  const Content({
    this.color,
    this.titleImageUrl,
    this.videoUrl,
    this.id,
    this.name,
    this.adult,
    this.releaseDate,
    this.runtime,
    this.overview,
    this.tagLine,
    this.posterPath,
    this.backdropPath,
    this.mediaType,
    this.genresList,
    this.castList,
    this.videos,
    this.backdropsList,
    this.postersList,
    this.collection,
    this.voteCount,
    this.voteAverage,
    this.budget,
    this.revenue,
    this.status,
    this.homepage,

    this.imdbId,
    this.season,
  });

  // TODO Expand Images onTap
  // TODO Like Button Animation
  // TODO Person's screen
  // TODO Collection Screen
  // TODO Loading Screen (Netflix Logo under Shimmer effect)

  factory Content.fromJson(Map<String, dynamic> json, String mediaType) {
    // final isMovie = json['media_type'] == 'movie';

    return Content(
      id: json['id'] as int,
      // name: isMovie ? json['title'] as String : json['name'] as String,
      name: json['title'] as String ?? json['name'] as String,
      posterPath: (json['poster_path'] != null)
          ? tmdbImagesBaseUrl + (json['poster_path'] as String)
          : null,
      backdropPath: (json['backdrop_path'] != null)
          ? tmdbImagesBaseUrl + (json['backdrop_path'] as String)
          : null,
      mediaType: json['media_type'] as String ?? mediaType,
      releaseDate: json['release_date'] ?? json['first_air_date'],
      overview: json['overview'] as String,
      voteAverage: json['vote_average'] as double,
      voteCount: json['vote_count'] as int,
    );
  }

// Future<Content> getContentDetails() async {
//   try {
//     http.Response response =
//     await http.get(baseUrl + 'movie/$id?api_key=$apiKey');
//
//     final parsed = jsonDecode(response.body);
//
//     final Content res = Content(
//       id: parsed['id'] as int,
//       adult: parsed['adult'] as bool,
//       name: parsed['title'] as String ?? parsed['name'] as String,
//       mediaType: parsed['media_type'] as String,
//       backdropPath: (parsed['backdrop_path'] != null)
//           ? tmdbImagesBaseUrl + (parsed['backdrop_path'] as String)
//           : null,
//       posterPath: (parsed['poster_path'] != null)
//           ? tmdbImagesBaseUrl + (parsed['poster_path'] as String)
//           : null,
//       imdbId: parsed['imdb_id'],
//       runtime: parsed['runtime'] as int ?? 90,
//       overview: parsed['overview'],
//       releaseDate: parsed['release_date'] ?? parsed['first_air_date'],
//       status: parsed['status'] as String,
//       tagLine: parsed['tagline'] as String,
//       voteAverage: parsed['vote_average'] as double,
//       voteCount: parsed['vote_count'] as int,
//       genresList: (parsed['genres'].cast<Map<String, dynamic>>())
//           .map<Genre>((json) => Genre.fromJson(json))
//           .toList(),
//     );
//
//     return res;
//   } catch (e) {
//     throw Exception(e);
//   }
// }
}
