import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/data/models/models.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class CircularContentScroll extends StatelessWidget {
  final List<Cast> castList;
  final String title;

  const CircularContentScroll({
    Key key,
    @required this.castList,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 16.0),
        SizedBox(
          height: 160.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: castList.length,
              itemBuilder: (BuildContext context, int index) {
                final cast = castList[index];
                return _ScrollElement(cast: cast);
              },
          ),
        )
      ],
    );
  }
}

class _ScrollElement extends StatelessWidget {
  final Cast cast;

  const _ScrollElement({Key key, @required this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uuid = Uuid().v1();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      width: 92.0,
      child: GestureDetector(
        onTap: () => print(cast.id),
        child: Column(
          children: [
            cast.profilePath != null && cast.profilePath.length > 1
                ? Hero(
                  tag: '$uuid',
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: CachedNetworkImage(
                        height: 72.0,
                        width: 72.0,
                        imageUrl: "${cast.profilePath}",
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: Colors.white,
                          size: 40.0,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 72.0,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                )
                : Icon(
                    Icons.account_circle_outlined,
                    size: 72.0,
                    color: Colors.white,
                  ),
            const SizedBox(height: 6.0),
            Text(
              cast.name ?? 'Undefined name',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6.0),
            cast.character != null && cast.character.length > 0
                ? Text(
                    cast.character,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
