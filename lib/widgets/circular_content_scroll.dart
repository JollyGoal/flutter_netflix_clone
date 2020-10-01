import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/models/models.dart';

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: castList.length,
              itemBuilder: (BuildContext context, int index) {
                final cast = castList[index];
                return _ScrollElement(cast: cast);
              },
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      width: 92.0,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36.0,
            backgroundColor: Colors.grey,
            backgroundImage: Image.network(cast.profile_path).image,
          ),
          const SizedBox(height: 6.0),
          Text(
            cast.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6.0),
          Text(
            cast.character,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
