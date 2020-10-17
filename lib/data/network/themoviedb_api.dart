import 'package:flutter_netflix_responsive/data/models/all_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TheMovieDBApi {
  /// Throws [NetworkException].
  Future<List<Content>> getTrending(String timeWindow, String mediaType);

  Future<List<Content>> getSimilar(int id, String mediaType);

  Future<List<Content>> getRecommendations(int id, String mediaType);

  Future<Content> getMovieDetails(int id);
}

class TheMovieDBRepository implements TheMovieDBApi {
  @override
  Future<List<Content>> getTrending(String timeWindow, String mediaType) async {
    try {
      http.Response response = await http.get(
          apiBaseUrl + 'trending/$mediaType/$timeWindow?api_key=$apiKey&page=1');

      return parseContentList(response.body, mediaType);
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<List<Content>> getSimilar(int id, String mediaType) async {
    try {
      http.Response response = await http
          .get(apiBaseUrl + '$mediaType/$id/similar?api_key=$apiKey&page=1');

      return parseContentList(response.body, mediaType);
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<List<Content>> getRecommendations(int id, String mediaType) async {
    try {
      http.Response response = await http.get(
          apiBaseUrl + '$mediaType/$id/recommendations?api_key=$apiKey&page=1');

      return parseContentList(response.body, mediaType);
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<Content> getMovieDetails(int id) async {
    try {
      http.Response response = await http.get(apiBaseUrl +
          'movie/$id?api_key=$apiKey&append_to_response=videos%2Ccredits%2Cimages');

      final parsed = jsonDecode(response.body);

      final Content res = Content(
        id: parsed['id'] as int,
        adult: parsed['adult'] as bool ?? false,
        name: parsed['title'] as String ?? parsed['name'] as String,
        mediaType: 'movie',
        backdropPath: (parsed['backdrop_path'] != null)
            ? tmdbImagesBaseUrl + (parsed['backdrop_path'] as String)
            : null,
        posterPath: (parsed['poster_path'] != null)
            ? tmdbImagesBaseUrl + (parsed['poster_path'] as String)
            : null,
        imdbId: parsed['imdb_id'],
        runtime: parsed['runtime'] as int ?? 90,
        overview: parsed['overview'],
        releaseDate: parsed['release_date'] ?? parsed['first_air_date'],
        status: parsed['status'] as String,
        tagLine: parsed['tagline'] as String,
        voteAverage: parsed['vote_average'] as double,
        voteCount: parsed['vote_count'] as int,
        genresList: (parsed['genres'].cast<Map<String, dynamic>>())
            .map<Genre>((json) => Genre.fromJson(json))
            .toList(),
        castList: ((parsed['credits']['cast']).cast<Map<String, dynamic>>())
            .map<Cast>((json) => Cast.fromJson(json))
            .toList(),
        videos: ((parsed['videos']['results']).cast<Map<String, dynamic>>())
            .map<Video>((json) =>
                (json['site'] == 'YouTube') ? Video.fromJson(json) : null)
            .toList(),
        backdropsList:
            ((parsed['images']['backdrops']).cast<Map<String, dynamic>>())
                .map<String>((json) => '$tmdbImagesBaseUrl${json['file_path']}')
                .toList(),
        postersList:
            ((parsed['images']['posters']).cast<Map<String, dynamic>>())
                .map<String>((json) => '$tmdbImagesBaseUrl${json['file_path']}')
                .toList(),
        collection: parsed['belongs_to_collection'] != null
            ? Collection.fromJson(
                parsed['belongs_to_collection'] as dynamic)
            : null,
      );

      res.videos.removeWhere((element) => element == null);

      return res;
    } catch (e) {
      throw NetworkException();
    }
  }
}

List<Content> parseContentList(String responseBody, String mediaType) {
  // final parsed = jsonDecode(responseBody)['results'] as List;
  final parsed =
      jsonDecode(responseBody)['results'].cast<Map<String, dynamic>>();

  return parsed
      .map<Content>((json) => Content.fromJson(json, mediaType))
      .toList();
}

class NetworkException implements Exception {}
