import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatelessWidget {
  final int score;
  const Rating({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: score.toDouble(),
      itemBuilder: (context, index) =>  const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: score,
      itemSize: 20.0,
    );
  }
}
