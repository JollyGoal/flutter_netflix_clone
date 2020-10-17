import 'package:bloc/bloc.dart';
import 'package:flutter_netflix_responsive/data/models/all_models.dart';
import 'package:flutter_netflix_responsive/data/network/themoviedb_api.dart';
import 'package:meta/meta.dart';

part 'tmdb_api_state.dart';

class TmdbApiCubit extends Cubit<TmdbApiState> {
  final TheMovieDBApi _theMovieDBApi;

  TmdbApiCubit(this._theMovieDBApi) : super(TmdbApiInitial());

  Future<void> getTrendingData(String timeWindow, String mediaType) async {
    try {
      emit(TmdbApiLoading());
      final instance = await _theMovieDBApi.getTrending(timeWindow, mediaType);
      emit(TmdbApiListLoaded(instance));
    } on NetworkException {
      emit(TmdbApiError('Failed to fetch data from network'));
    }
  }

  Future<void> getMovieData(int id) async {
    try {
      emit(TmdbApiLoading());

      final instance = await _theMovieDBApi.getMovieDetails(id);

      /// The following future is made in
      /// Loading UI testing purposes
      await Future.delayed(Duration(seconds: 1));

      emit(TmdbApiContentLoaded(instance));
    } on NetworkException {
      emit(TmdbApiError('Failed to fetch data from network'));
    }
  }

  Future<void> getSimilarContent(int id, String mediaType) async {
    try {
      emit(TmdbApiLoading());
      final instance = await _theMovieDBApi.getSimilar(id, mediaType);
      emit(TmdbApiListLoaded(instance));
    } on NetworkException {
      emit(TmdbApiError('Failed to fetch data from network'));
    }
  }

  Future<void> getRecommendedContent(int id, String mediaType) async {
    try {
      emit(TmdbApiLoading());
      final instance = await _theMovieDBApi.getRecommendations(id, mediaType);
      emit(TmdbApiListLoaded(instance));
    } on NetworkException {
      emit(TmdbApiError('Failed to fetch data from network'));
    }
  }
}
