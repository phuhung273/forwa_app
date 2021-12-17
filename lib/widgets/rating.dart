import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatelessWidget {
  final int score;
  final double size;
  final Color? color;

  const Rating({
    Key? key,
    required this.score,
    this.size = 20.0,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: score.toDouble(),
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: color ?? Colors.amber,
      ),
      itemCount: score,
      itemSize: size,
    );
  }
}
