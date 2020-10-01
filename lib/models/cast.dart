import 'package:meta/meta.dart';

class Cast {
  final int id;
  final String character;
  final String name;
  final String profile_path;

  const Cast({
    @required this.id,
    this.character = 'Unknown character',
    this.name = 'Undefined Name',
    this.profile_path = 'https://image.tmdb.org/t/p/w600_and_h900_bestv2/d9HyjGMCt4wgJIOxAGlaYWhKsiN.jpg',
  });
}
