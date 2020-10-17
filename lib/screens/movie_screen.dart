import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_netflix_responsive/cubits/tmdb_api/tmdb_api_cubit.dart';
import 'package:flutter_netflix_responsive/data/models/content_model.dart';
import 'package:flutter_netflix_responsive/data/models/all_models.dart';
import 'package:flutter_netflix_responsive/data/network/themoviedb_api.dart';
import 'package:flutter_netflix_responsive/widgets/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

class MovieScreen extends StatefulWidget {
  final Content movie;
  final String uuid;

  const MovieScreen({
    Key key,
    @required this.movie,
    @required this.uuid,
  }) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  Content movie;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  BuildContext newContext;

  Future<void> _onRefresh() async {
    // monitor network fetch
    try {
      newContext.bloc<TmdbApiCubit>().getMovieData(movie.id);
    } catch (e) {
      print(e);
    }
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use loadNoData()
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  final List<String> debugScreenshots = const [
    'https://fanart.tv/fanart/movies/45745/moviethumb/sintel-5420511f4629a.jpg',
    'https://fanart.tv/fanart/movies/45745/moviebackground/sintel-53805ef6066b5.jpg',
    'https://fanart.tv/fanart/movies/45745/moviebackground/sintel-53805ef612aa3.jpg',
    'https://fanart.tv/fanart/movies/45745/moviebackground/sintel-53805ef61a2af.jpg',
    'https://fanart.tv/fanart/movies/45745/movieposter/sintel-53805ed85c99a.jpg'
  ];

  @override
  void initState() {
    super.initState();

    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<TmdbApiCubit>(
        create: (_) => TmdbApiCubit(TheMovieDBRepository()),
        child: Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.grey[850],
            child: const Icon(Icons.arrow_back_ios_outlined),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _onRefresh,
            // enablePullUp: true,
            // onLoading: _onLoading,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                        child: Hero(
                          tag: widget.uuid,
                          child: ClipShadowPath(
                            clipper: CircularClipper(),
                            shadow: Shadow(blurRadius: 20.0),
                            child: CachedNetworkImage(
                              height: 500.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: "${movie.posterPath}",
                              placeholder: (context, url) =>
                                  SpinKitFadingCircle(
                                color: Colors.white,
                                size: 50.0,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                        height: 500.0,
                        child: ClipPath(
                          clipper: CircularClipper(),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black87, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RawMaterialButton(
                            padding: EdgeInsets.all(10.0),
                            elevation: 12.0,
                            onPressed: () => print('Play Video'),
                            shape: CircleBorder(),
                            fillColor: Colors.grey[850],
                            child: Icon(
                              Icons.play_arrow,
                              size: 60.0,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 25.0,
                        child: IconButton(
                          onPressed: () => print('Add to Favorites'),
                          icon: Icon(Icons.favorite_border),
                          iconSize: 40.0,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 25.0,
                        child: IconButton(
                          onPressed: () => shareTitle(),
                          icon: Icon(Icons.share),
                          iconSize: 35.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 28.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width - 108.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  BlocConsumer<TmdbApiCubit, TmdbApiState>(
                                    listener: (context, state) {
                                      if (state is TmdbApiError) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(state.message),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      newContext = context;
                                      if (state is TmdbApiInitial) {
                                        context
                                            .bloc<TmdbApiCubit>()
                                            .getMovieData(movie.id);
                                      }
                                      if (state is TmdbApiContentLoaded) {
                                        return buildMetaInfoWrap(
                                            state.instance);
                                      } else if (state is TmdbApiInitial ||
                                          state is TmdbApiLoading) {
                                        return buildMetaInfoLoadingWrap();
                                      } else {
                                        return Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.white,
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            Ink(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                onTap: () => print('Add to List'),
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  child: Icon(
                                    Icons.add,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28.0),
                        BlocBuilder<TmdbApiCubit, TmdbApiState>(
                          builder: (context, state) {
                            if (state is TmdbApiLoading ||
                                state is TmdbApiInitial) {
                              return buildGenresLoadingWrap();
                            } else if (state is TmdbApiContentLoaded) {
                              return state.instance.genresList != null &&
                                      state.instance.genresList.isNotEmpty
                                  ? buildGenresWrap(state.instance.genresList)
                                  : SizedBox.shrink();
                            } else {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_outlined,
                                    color: Colors.white,
                                    size: 28.0,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Container(
                                    width: size.width - 92.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Error occurred while loading data, please reload the page',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 28.0),
                        BlocBuilder<TmdbApiCubit, TmdbApiState>(
                          builder: (context, state) {
                            if (state is TmdbApiContentLoaded &&
                                state.instance.tagLine.length > 0) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 20.0),
                                child: Text(
                                  state.instance.tagLine,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.0,
                                  ),
                                ),
                              );
                            } else if (state is TmdbApiLoading ||
                                state is TmdbApiInitial) {
                              /// TODO Change to Shimmers Column with 2 children
                              /// First child: 85% of width Shimmer
                              /// Second child 15% of width Shimmer
                              return SizedBox.shrink();
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                        Text(
                          'Plot Summary',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          movie.overview ?? 'No overview.',
                          style: const TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: const Divider(color: Colors.white),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                    builder: (context, state) {
                      return MediaTabBarBuilder(state: state);
                    },
                  ),
                ),
                /// TODO Votes Container
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(vertical: 28.0),
                //   sliver: SliverToBoxAdapter(
                //     child: SizedBox(),
                //   ),
                // ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                      builder: (context, state) {
                        if (state is TmdbApiInitial ||
                            state is TmdbApiLoading) {
                          return CircularContentScrollLoading(
                              title: 'Top Billed Cast');
                        } else if (state is TmdbApiContentLoaded) {
                          return state.instance.castList != null &&
                                  state.instance.castList.length > 0
                              ? CircularContentScroll(
                                  title: 'Top Billed Cast',
                                  castList: state.instance.castList,
                                )
                              : SizedBox.shrink();
                        } else {
                          return ContentListError(title: 'Top Billed Cast');
                        }
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                    builder: (context, state) {
                      if (state is TmdbApiInitial || state is TmdbApiLoading) {
                        return SizedBox.shrink();
                      } else if (state is TmdbApiContentLoaded &&
                          state.instance.collection != null) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 28.0),
                          width: double.infinity,
                          height: 240.0,
                          child: _CollectionBanner(
                            name: state.instance.collection.name,
                            imgUrl: state.instance.collection.backdropPath,
                            onPressed: () =>
                                print('${state.instance.collection.id}'),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocProvider<TmdbApiCubit>(
                    create: (_) => TmdbApiCubit(TheMovieDBRepository()),
                    child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                      builder: (context, state) {
                        return ContentListBuilder(
                          title: "Similar Movies",
                          invoker: () => context
                              .bloc<TmdbApiCubit>()
                              .getSimilarContent(movie.id, movie.mediaType),
                          state: state,
                        );
                      },
                    ),
                  ),
                ),
                // TODO MovieScreen bottom container
              ],
            ),
          ),
        ));
  }

  Wrap buildMetaInfoWrap(Content movie) {
    final hMin = durationToString(movie.runtime);
    return Wrap(
      spacing: 16.0,
      direction: Axis.horizontal,
      children: [
        Text(
          '${movie.releaseDate.substring(0, 4)}',
          style: const TextStyle(
            color: Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          movie.adult ? 'NC-17' : 'PG-13',
          style: const TextStyle(
            color: Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          hMin,
          style: const TextStyle(
            color: Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Wrap buildMetaInfoLoadingWrap() {
    /// TODO implement Shimmers
    return Wrap(
      direction: Axis.horizontal,
      spacing: 16.0,
      children: [
        /// Remove when adding Shimmers
        SizedBox(
          height: 16.0,
          width: 16.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }

  Wrap buildGenresWrap(List<Genre> genres) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 12.0,
      runSpacing: 10.0,
      children: genres
          .map((Genre elem) => CustomChip(
                label: elem.name,
                onTap: () => print(elem.id),
              ))
          .toList(),
    );
  }

  Wrap buildGenresLoadingWrap() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 12.0,
      runSpacing: 10.0,
      children: [
        CustomLoadingChip(),
        CustomLoadingChip(),
        CustomLoadingChip(),
      ],
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
  }

  void shareTitle() {
    Share.share(
      'Check out this awesome ${movie.mediaType}:\n$shareUrl${movie.mediaType}/${movie.id}',
      subject: 'You should definitely check this!',
    );
  }
}

class _CollectionBanner extends StatelessWidget {
  final String name;
  final String imgUrl;
  final Function onPressed;

  const _CollectionBanner({
    Key key,
    @required this.name,
    @required this.imgUrl,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CachedNetworkImage(
          height: double.infinity,
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerRight,
          imageUrl: imgUrl,
          errorWidget: (context, url, error) => Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 50.0,
          ),
        ),
        FutureBuilder(
          future: getImagePalette(CachedNetworkImageProvider(imgUrl)),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            final Color color = !snapshot.hasError && snapshot.hasData
                ? snapshot.data
                : Colors.black;

            return Stack(
              children: [
                Container(
                  color: color.withOpacity(0.4),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(
          width: size.width * 3 / 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Collection',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                FlatButton(
                  onPressed: onPressed,
                  color: Colors.red[900],
                  child: Text(
                    'VIEW COLLECTION',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<Color> getImagePalette(ImageProvider imageProvider) async {
  try {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
  } catch (e) {
    return Future.error('Something went wrong while getting dominant color');
  }
}
