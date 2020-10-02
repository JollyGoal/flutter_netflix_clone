import 'package:flutter/material.dart';

class ContentListError extends StatelessWidget {
  final String title;
  final bool isOriginals;
  final String errorText;
  final Function tryAgain;

  const ContentListError({
    Key key,
    @required this.title,
    this.isOriginals = false,
    this.errorText = 'Something went wrong',
    this.tryAgain,
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 60.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      errorText,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8.0),
                    tryAgain != null
                        ? FlatButton(
                      color: Colors.white,
                            onPressed: tryAgain,
                            child: Text(
                              'Try Again',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
