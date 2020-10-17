import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/cubits/tmdb_api/tmdb_api_cubit.dart';
import 'package:flutter_netflix_responsive/data/models/all_models.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaTabBarBuilder extends StatelessWidget {
  final dynamic state;

  const MediaTabBarBuilder({
    Key key,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is TmdbApiContentLoaded) {
      return buildData(
        state.instance.videos,
        state.instance.backdropsList,
        state.instance.postersList,
      );
    } else if (state is TmdbApiLoading || state is TmdbApiInitial) {
      return buildLoading();
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildLoading() {
    return SizedBox(
      height: 220.0,
      child: Center(
          child: SizedBox(
        height: 80.0,
        width: 80.0,
        child: CircularProgressIndicator(
          strokeWidth: 8.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )),
    );
  }

  Widget buildData(
    List<Video> videosList,
    List<String> backdropsList,
    List<String> postersList,
  ) {
    final int tabsCount =
        (videosList != null && videosList.isNotEmpty ? 1 : 0) +
            (backdropsList != null && backdropsList.isNotEmpty ? 1 : 0) +
            (postersList != null && postersList.isNotEmpty ? 1 : 0);

    return tabsCount > 0
        ? DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 4.0,
                    ),
                    insets: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  ),
                  indicatorWeight: 8.0,
                  labelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: "Videos",
                    ),
                    Tab(
                      text: "Backdrops",
                    ),
                    Tab(
                      text: "Posters",
                    ),
                  ],
                ),
                SizedBox(
                  height: 220,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      videosList != null && videosList.isNotEmpty
                          ? _YTVideosScroll(videosList: videosList)
                          : buildNoData(),
                      backdropsList != null && backdropsList.isNotEmpty
                          ? _ImagesScroll(images: backdropsList)
                          : buildNoData(),
                      postersList != null && postersList.isNotEmpty
                          ? _ImagesScroll(images: postersList)
                          : buildNoData(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Widget buildNoData() {
    return Center(
      child: Text(
        'No media to show.',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class _YTVideosScroll extends StatelessWidget {
  final List<Video> videosList;

  const _YTVideosScroll({Key key, @required this.videosList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: videosList.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 24.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: "${videosList[index].imageLink}",
                  placeholder: (context, url) => SizedBox(
                    width: 160.0,
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 72.0,
                    ),
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    width: 160.0,
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 72.0,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: RawMaterialButton(
                  onPressed: () =>
                      launchYouTubeVideo(context, videosList[index].key),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10.0),
                  elevation: 12.0,
                  fillColor: Colors.grey[850],
                  child: Icon(
                    Icons.play_arrow,
                    size: 50.0,
                    color: Colors.red[900],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void launchYouTubeVideo(context, String key) async {
    final url = 'https://www.youtube.com/watch?v=$key';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot launch URL'),
        ),
      );
    }
  }
}

class _ImagesScroll extends StatelessWidget {
  final List<String> images;

  const _ImagesScroll({
    Key key,
    @required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 24.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: "${images[index]}",
              placeholder: (context, url) => SizedBox(
                width: 160.0,
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 72.0,
                ),
              ),
              errorWidget: (context, url, error) => SizedBox(
                width: 160.0,
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 72.0,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
