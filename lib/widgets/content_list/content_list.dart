import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/data/models/models.dart';
import 'package:flutter_netflix_responsive/screens/screens.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class ContentList extends StatelessWidget {
  final String title;
  final List<Content> contentList;
  final bool isOriginals;

  const ContentList({
    Key key,
    @required this.title,
    @required this.contentList,
    this.isOriginals = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Container(
            height: isOriginals ? 500.0 : 220.0,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: contentList.length,
              itemBuilder: (BuildContext context, int index) {
                final Content content = contentList[index];
                final uuid = Uuid().v1();
                return GestureDetector(
                  onTap: () {
                    content.mediaType == 'movie'
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MovieScreen(movie: content, uuid: uuid),
                            ),
                          )
                        : print('not a movie');
                    // TODO TV Show Screen
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: isOriginals ? 400.0 : 200.0,
                    width: isOriginals ? 260.0 : 130.0,
                    child: Hero(
                      tag: '$uuid',
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: "${content.posterPath}",
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 50.0,
                        ),
                        fit: BoxFit.cover,
                      ),
                      // ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
