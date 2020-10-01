import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Function onTap;
  final String label;

  const CustomChip({
    Key key,
    @required this.onTap,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0
            ),
          ),
        ),
      ),
    );
  }
}
