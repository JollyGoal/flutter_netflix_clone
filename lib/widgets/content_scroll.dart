import 'package:flutter/material.dart';

class ContentScroll extends StatelessWidget {
  final List<String> images;
  final String title;
  final double imageHeight;

  const ContentScroll({
    Key key,
    @required this.images,
    @required this.title,
    @required this.imageHeight,
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
          height: imageHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                final imageUrl = images[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

// class _ScrollItem extends StatelessWidget {
//   final String imageUrl;
//
//   const _ScrollItem({Key key, @required this.imageUrl}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: imageHeight,
//     );
//   }
// }
