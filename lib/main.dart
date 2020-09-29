import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/screens/screens.dart';

import 'data/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Netflix UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black
      ),
      home: NavScreen(),
      // home: MovieScreen(movie: sintelContent),
      // routes: {
      //   '/a': (BuildContext context) => MyPage(title: 'page A'),
      //   '/b': (BuildContext context) => MyPage(title: 'page B'),
      //   '/c': (BuildContext context) => MyPage(title: 'page C'),
      // },
    );
  }
}