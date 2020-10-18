import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VotesSection extends StatefulWidget {
  final double voteAverage;
  final int voteCount;
  final Function(int) onTap;

  const VotesSection({
    Key key,
    @required this.voteAverage,
    @required this.voteCount,
    @required this.onTap,
  }) : super(key: key);

  @override
  _VotesSectionState createState() => _VotesSectionState();
}

class _VotesSectionState extends State<VotesSection> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: size.width / 2,
              child: Column(
                children: [
                  Text(
                    '${NumberFormat.compact().format(widget.voteCount) ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ratings Count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: size.width / 2,
              child: Column(
                children: [
                  Text(
                    '${widget.voteAverage ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Average User Score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                widget.onTap(1);
                setState(() {
                  rating = 1;
                });
              },
              child: Icon(
                rating > 0 ? Icons.star : Icons.star_outline,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onTap(2);
                setState(() {
                  rating = 2;
                });
              },
              child: Icon(
                rating > 1 ? Icons.star : Icons.star_outline,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onTap(3);
                setState(() {
                  rating = 3;
                });
              },
              child: Icon(
                rating > 2 ? Icons.star : Icons.star_outline,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onTap(4);
                setState(() {
                  rating = 4;
                });
              },
              child: Icon(
                rating > 3 ? Icons.star : Icons.star_outline,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onTap(5);
                setState(() {
                  rating = 5;
                });
              },
              child: Icon(
                rating > 4 ? Icons.star : Icons.star_outline,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}