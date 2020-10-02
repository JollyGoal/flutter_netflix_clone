import 'package:flutter/material.dart';

class ContentListLoading extends StatelessWidget {
  final String title;
  final bool isOriginals;

  const ContentListLoading({
    Key key,
    @required this.title,
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
            child:  Center(
              child: SizedBox(
                height: 80.0,
                width: 80.0,
                child: CircularProgressIndicator(
                  strokeWidth: 8.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white
                  ),
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}
