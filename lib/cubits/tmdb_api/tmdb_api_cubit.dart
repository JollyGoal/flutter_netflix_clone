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
      emit(TmdbApiLoaded(instance));
    } on NetworkException {
      emit(TmdbApiError('Failed to fetch data from network'));
    }

  }
}

class TmdbApiCubit2 extends Cubit<TmdbApiState> {
  TmdbApiCubit2() : super(TmdbApiInitial());
}
