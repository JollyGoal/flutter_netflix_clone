import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/data/data.dart';
import 'package:flutter_netflix_responsive/data/models/content_model.dart';
import 'package:flutter_netflix_responsive/data/models/all_models.dart';
import 'package:flutter_netflix_responsive/widgets/widgets.dart';

class MovieScreen extends StatefulWidget {
  final Content movie;
  final int index;

  const MovieScreen({Key key, @required this.movie, this.index = -1})
      : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final List<String> debugGenres = ['Action', 'Thriller', 'Fantasy', 'Comedy'];
  final List<String> debugScreenshots = [
    'https://fanart.tv/fanart/movies/45745/moviethumb/sintel-5420511f4629a.jpg',
    'https://fanart.tv/fanart/movies/45745/moviebackground/sintel-53805ef6066b5.jpg',
    'https://fanart.tv/fanart/movies/45745/moviebackground/sintel-53805ef612aa3.jpg',
    'https://fanart.tv/fanart/movies/45745/moviebackground/sintel-53805ef61a2af.jpg',
    'https://fanart.tv/fanart/movies/45745/movieposter/sintel-53805ed85c99a.jpg'
  ];
  final List<Cast> debugCastList = [
    Cast(
      id: 0,
      character: 'Ted Logan',
      name: 'Keanu Reeves',
    ),
    Cast(
      id: 1,
      character: 'Bill S. Preston',
      name: 'Alex Winter',
      profilePath:
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2/3kZFRlc8zvfvziJIc7HxY803HXi.jpg',
    ),
    Cast(
      id: 2,
      character: 'Kelly',
      name: 'Kristen Schaal',
      profilePath:
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2/s3LSHVTx8gxHP2twYsXEGa8JbLl.jpg',
    ),
    Cast(
      id: 3,
      character: 'Thea Preston',
      name: 'Samara Weaving',
      profilePath:
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2/5MzsIWtOKnTRYQ8fBpFCDgwMqNF.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.grey[850],
        child: const Icon(Icons.arrow_back_ios_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: ListView(
        children: [
          Stack(
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                child: Hero(
                  tag: widget.index != -1
                      ? '${widget.index}-${widget.movie.imageUrl}'
                      : widget.movie.imageUrl,
                  child: ClipShadowPath(
                    clipper: CircularClipper(),
                    shadow: Shadow(blurRadius: 20.0),
                    child: Image(
                      height: 500.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      image: AssetImage(widget.movie.imageUrl),
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
              // Row(
              //   children: <Widget>[
              //     IconButton(
              //       padding: EdgeInsets.only(left: 20.0),
              //       onPressed: () => Navigator.pop(context),
              //       icon: Icon(Icons.arrow_back_ios_outlined),
              //       iconSize: 30.0,
              //       color: Colors.black,
              //     ),
              //     Expanded(
              //       child: Image(
              //         image: AssetImage('assets/images/netflix_logo1.png'),
              //         height: 40.0,
              //       ),
              //     ),
              //     IconButton(
              //       padding: EdgeInsets.only(right: 20.0),
              //       onPressed: () => print('Add to Favorites'),
              //       icon: Icon(Icons.favorite_border),
              //       iconSize: 30.0,
              //       color: Colors.black,
              //     ),
              //   ],
              // ),
              Positioned.fill(
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(10.0),
                    elevation: 12.0,
                    onPressed: () => print('Play Video'),
                    shape: CircleBorder(),
                    fillColor: Colors.red,
                    child: Icon(
                      Icons.play_arrow,
                      size: 60.0,
                      color: Colors.white,
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
                  onPressed: () => print('Share'),
                  icon: Icon(Icons.share),
                  iconSize: 35.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                            widget.movie.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                            ),
                          ),
                          // Text(
                          //   widget.movie.name,
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 22.0,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          const SizedBox(height: 6.0),
                          Wrap(
                            spacing: 16.0,
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                '2020',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                'PG-13',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                '2h 30min',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
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
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 12.0,
                  runSpacing: 10.0,
                  children: debugGenres
                      .map((e) => CustomChip(
                            label: e,
                            onTap: () => print(e),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 28.0),
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
                  widget.movie.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28.0),
          const Divider(color: Colors.white),
          const SizedBox(height: 16.0),
          ContentScroll(
            images: debugScreenshots,
            title: 'Media',
            imageHeight: 144.0,
          ),
          const SizedBox(height: 28.0),
          CircularContentScroll(
            title: 'Cast & Crew',
            castList: debugCastList,
          ),
          ContentList(
            title: 'Similar Movies',
            contentList: originals,
          )
        ],
      ),
    );
  }
}
