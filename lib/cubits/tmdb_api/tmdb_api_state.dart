part of 'tmdb_api_cubit.dart';

@immutable
abstract class TmdbApiState {
  const TmdbApiState();
}

class TmdbApiInitial extends TmdbApiState {
  const TmdbApiInitial();
}

class TmdbApiLoading extends TmdbApiState {
  const TmdbApiLoading();
}

class TmdbApiLoaded extends TmdbApiState {
  final List<Content> instance;

  const TmdbApiLoaded(this.instance);
}

class TmdbApiError extends TmdbApiState {
  final String message;

  const TmdbApiError(this.message);
}

