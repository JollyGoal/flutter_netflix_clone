import 'package:flutter/cupertino.dart';

class Genre {
  final int id;
  final String name;

  const Genre({
    @required this.id,
    @required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
