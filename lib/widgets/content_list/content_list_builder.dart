import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/cubits/tmdb_api/tmdb_api_cubit.dart';
import 'package:flutter_netflix_responsive/data/models/models.dart';
import 'package:flutter_netflix_responsive/widgets/widgets.dart';

class ContentListBuilder extends StatelessWidget {
  final String title;
  final String storageKey;
  final Function invoker;
  final dynamic state;

  const ContentListBuilder({
    Key key,
    @required this.title,
    this.storageKey,
    @required this.invoker,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is TmdbApiInitial) {
      invoker();
      return buildLoading();
    } else if (state is TmdbApiLoading) {
      return buildLoading();
    } else if (state is TmdbApiListLoaded) {
      return (state.instance.length > 0)
          ? buildDataList(state.instance)
          : SizedBox.shrink();
    } else {
      if (state is TmdbApiError) {
        return ContentListError(
          title: title,
          tryAgain: invoker,
          errorText: state.message,
        );
      } else {
        return ContentListError(
          title: title,
          tryAgain: invoker,
        );
      }
    }
  }

  ContentList buildDataList(List<Content> data) {
    if (storageKey != null) {
      return ContentList(
        key: PageStorageKey(storageKey),
        title: title,
        contentList: data,
      );
    } else {
      return ContentList(
        title: title,
        contentList: data,
      );
    }
  }

  ContentListLoading buildLoading() {
    return ContentListLoading(title: title);
  }
}
