import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_netflix_responsive/config/palette.dart';
import 'package:flutter_netflix_responsive/config/utils.dart';
import 'package:flutter_netflix_responsive/cubits/tmdb_api/tmdb_api_cubit.dart';
import 'package:flutter_netflix_responsive/data/models/models.dart';
import 'package:flutter_netflix_responsive/data/network/themoviedb_api.dart';
import 'package:flutter_netflix_responsive/widgets/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Content movie;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  BuildContext newContext;

  Future<void> _onRefresh() async {
    try {
      await newContext.bloc<TmdbApiCubit>().getMovieData(movie.id);
    } catch (e) {
      _refreshController.refreshFailed();
    }
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use loadNoData()
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

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
        key: _scaffoldKey,
        backgroundColor: Palette.nightBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Palette.nightBackgroundLight,
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
                            placeholder: (context, url) => SpinKitFadingCircle(
                              color: Palette.fontPrimary,
                              size: 50.0,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              color: Palette.fontPrimary,
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
                          fillColor: Palette.nightBackgroundLight,
                          child: Icon(
                            Icons.play_arrow,
                            size: 60.0,
                            color: Palette.primaryRed,
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
                        color: Palette.fontPrimary,
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 25.0,
                      child: IconButton(
                        onPressed: () => shareTitle(movie.mediaType, movie.id),
                        icon: Icon(Icons.share),
                        iconSize: 35.0,
                        color: Palette.fontPrimary,
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
                                    color: Palette.fontPrimary,
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
                                      return buildMetaInfoWrap(state.instance);
                                    } else if (state is TmdbApiInitial ||
                                        state is TmdbApiLoading) {
                                      return buildMetaInfoLoadingWrap();
                                    } else {
                                      return Icon(
                                        Icons.warning_amber_outlined,
                                        color: Palette.fontPrimary,
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          Ink(
                            decoration: BoxDecoration(
                              color: Palette.fontPrimary,
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
                                  color: Palette.fontPrimary,
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
                                          color: Palette.fontPrimary,
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
                              padding: const EdgeInsets.only(bottom: 20.0),
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
                          color: Palette.fontPrimary,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        movie.overview ?? 'No overview.',
                        style: const TextStyle(
                          color: Palette.fontSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: const Divider(
                  color: Palette.fontPrimary,
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                  builder: (context, state) {
                    return MediaTabBarBuilder(state: state);
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: const Divider(
                  color: Palette.fontPrimary,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                sliver: SliverToBoxAdapter(
                  child: VotesSection(
                    voteAverage: movie.voteAverage,
                    voteCount: movie.voteCount,
                    onTap: (int rating) =>
                        _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Your vote has been sent'),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: const Divider(
                  color: Palette.fontPrimary,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                    builder: (context, state) {
                      if (state is TmdbApiInitial || state is TmdbApiLoading) {
                        return CircularContentScrollLoading(title: 'Full Cast');
                      } else if (state is TmdbApiContentLoaded) {
                        return state.instance.castList != null &&
                                state.instance.castList.length > 0
                            ? CircularContentScroll(
                                title: 'Full Cast',
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
              SliverToBoxAdapter(
                child: BlocBuilder<TmdbApiCubit, TmdbApiState>(
                  builder: (context, state) {
                    if (state is TmdbApiContentLoaded) {
                      return _BottomContainer(
                        budget: state.instance.budget,
                        revenue: state.instance.revenue,
                        status: state.instance.status,
                        homepage: state.instance.homepage,
                      );
                    } else {
                      return _BottomContainer();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Wrap buildMetaInfoWrap(Content movie) {
    return Wrap(
      spacing: 16.0,
      direction: Axis.horizontal,
      children: [
        Text(
          '${movie.releaseDate.substring(0, 4)}',
          style: const TextStyle(
            color: Palette.fontSecondary,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          movie.adult ? 'NC-17' : 'PG-13',
          style: const TextStyle(
            color: Palette.fontSecondary,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          durationToString(movie.runtime),
          style: const TextStyle(
            color: Palette.fontSecondary,
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
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          imageUrl: imgUrl,
          errorWidget: (context, url, error) => Icon(
            Icons.error_outline,
            color: Palette.fontPrimary,
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
                : Palette.nightBackground;

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
                    color: Palette.fontPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                FlatButton(
                  onPressed: onPressed,
                  color: Palette.primaryRed,
                  child: Text(
                    'VIEW COLLECTION',
                    style: const TextStyle(
                      color: Palette.fontPrimary,
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

class _BottomContainer extends StatelessWidget {
  final int budget;
  final int revenue;
  final String status;
  final String homepage;

  const _BottomContainer({
    Key key,
    this.budget = 0,
    this.revenue = 0,
    this.status = "",
    this.homepage = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (size.width - 48.0) / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: const TextStyle(
                          color: Palette.fontPrimary,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        status.length > 0 ? status : 'Undefined',
                        style: const TextStyle(
                          color: Palette.fontSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: (size.width - 48.0) / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      homepage.length > 1
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Homepage',
                                  style: const TextStyle(
                                    color: Palette.fontPrimary,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                GestureDetector(
                                  onTap: () => launchUrl(
                                    context,
                                    homepage,
                                  ),
                                  child: Icon(
                                    Icons.open_in_new_outlined,
                                    color: Palette.fontPrimary,
                                    size: 22.0,
                                  ),
                                )
                              ],
                            )
                          : Text(
                              'Homepage',
                              style: const TextStyle(
                                color: Palette.fontPrimary,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      const SizedBox(height: 6.0),
                      Text(
                        homepage.length > 1 ? homepage : 'No homepage',
                        style: const TextStyle(
                          color: Palette.fontSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (size.width - 48.0) / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget',
                        style: const TextStyle(
                          color: Palette.fontPrimary,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        budget > 0
                            ? '${NumberFormat.compactCurrency(symbol: "\$ ").format(budget)}'
                            : '---/---/---',
                        style: const TextStyle(
                          color: Palette.fontSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: (size.width - 48.0) / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenue',
                        style: const TextStyle(
                          color: Palette.fontPrimary,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        revenue > 0
                            ? '${NumberFormat.compactCurrency(symbol: "\$ ").format(revenue)}'
                            : '---/---/---',
                        style: const TextStyle(
                          color: Palette.fontSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
