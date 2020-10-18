import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/cubits/app_bar/app_bar_cubit.dart';
import 'package:flutter_netflix_responsive/cubits/tmdb_api/tmdb_api_cubit.dart';
import 'package:flutter_netflix_responsive/data/data.dart';
import 'package:flutter_netflix_responsive/data/models/models.dart';
import 'package:flutter_netflix_responsive/data/network/themoviedb_api.dart';
import 'package:flutter_netflix_responsive/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        context.bloc<AppBarCubit>().setOffset(_scrollController.offset);
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        child: const Icon(Icons.cast),
        onPressed: () => print('Cast'),
      ),
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (context, state) {
            return CustomAppBar(scrollOffset: state);
          },
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ContentHeader(featuredContent: sintelContent),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            sliver: SliverToBoxAdapter(
              child: Previews(
                key: PageStorageKey('previews'),
                title: 'Previews',
                contentList: previews,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocProvider<TmdbApiCubit>(
              create: (_) => TmdbApiCubit(TheMovieDBRepository()),
              child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                // listener: (context, state) {
                //   if (state is TmdbApiError) {
                //     Scaffold.of(context)
                //         .showSnackBar(SnackBar(content: Text(state.message)));
                //   }
                // },
                builder: (context, state) {
                  final title = "Trending Today";
                  final storageKey = "trendDay";
                  final Function invoker = () => context
                      .bloc<TmdbApiCubit>()
                      .getTrendingData('day', 'all');

                  if (state is TmdbApiInitial) {
                    invoker();
                    return buildLoading(title);
                  } else if (state is TmdbApiLoading) {
                    return buildLoading(title);
                  } else if (state is TmdbApiListLoaded) {
                    return buildDataList(state.instance, storageKey, title);
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
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocProvider<TmdbApiCubit>(
              create: (_) => TmdbApiCubit(TheMovieDBRepository()),
              child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                // listener: (context, state) {
                //   if (state is TmdbApiError) {
                //     Scaffold.of(context)
                //         .showSnackBar(SnackBar(content: Text(state.message)));
                //   }
                // },
                builder: (context, state) {
                  return ContentListBuilder(
                    storageKey: "trendWeek",
                    title: "Trends Of the Week",
                    invoker: () => context
                        .bloc<TmdbApiCubit>()
                        .getTrendingData('week', 'all'),
                    state: state,
                  );
                },
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: ContentList(
          //     key: PageStorageKey('myList'),
          //     title: 'My List',
          //     contentList: myList,
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: ContentList(
          //     key: PageStorageKey('originals'),
          //     title: 'Originals',
          //     contentList: originals,
          //     isOriginals: true,
          //   ),
          // ),
          // SliverPadding(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   sliver: SliverToBoxAdapter(
          //     child: ContentList(
          //       key: PageStorageKey('trending'),
          //       title: 'Trending',
          //       contentList: trending,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  ContentList buildDataList(List<Content> data, String key, String title) {
    return ContentList(
      key: PageStorageKey(key),
      title: title,
      contentList: data,
    );
  }

  ContentListLoading buildLoading(String title) {
    return ContentListLoading(title: title);
  }
}
