import 'package:flutter_netflix_responsive/data/models/all_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TheMovieDBApi {
  /// Throws [NetworkException].
  Future<List<Content>> getTrending(String timeWindow, String mediaType);
}

const String baseUrl = "https://api.themoviedb.org/3/";
const String apiKey = "dbe6bbade89a0d98b04e6de2f6a50c10";

class TheMovieDBRepository implements TheMovieDBApi {
  @override
  Future<List<Content>> getTrending(String timeWindow, String mediaType) async {
    try {
      http.Response response = await http
          .get(baseUrl + 'trending/$mediaType/$timeWindow?api_key=$apiKey');

      // List<Content> data = parseContent(response.body);
      //
      // print(data);

      return parseContent(response.body);
    } catch (e) {
      throw NetworkException();
    }
  }
}

class NetworkException implements Exception {}

List<Content> parseContent(String responseBody) {
  final parsed = jsonDecode(responseBody)['results'].cast<Map<String, dynamic>>();

  return parsed.map<Content>((json) => Content.fromJson(json)).toList();
}
