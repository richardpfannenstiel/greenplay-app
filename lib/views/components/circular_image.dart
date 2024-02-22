import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    required this.imageString,
    required this.size,
    this.backgroundColor,
  });
  final String imageString;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (backgroundColor != null) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: size,
        child: CircleAvatar(
          radius: size - 5,
          backgroundImage: AssetImage(imageString),
          backgroundColor: backgroundColor,
        ),
      );
    } else {
      return CircleAvatar(
        radius: size,
        backgroundImage: AssetImage(imageString),
      );
    }
  }
}
