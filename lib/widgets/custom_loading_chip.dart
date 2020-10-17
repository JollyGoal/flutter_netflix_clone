import 'dart:math';

import 'package:flutter/material.dart';

class CustomLoadingChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rng = Random().nextInt(22).toDouble();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
              color: Colors.white,
              width: 2.0
          )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 10.0,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0 + rng),
          child: SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
