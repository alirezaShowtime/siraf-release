import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/helpers.dart';

class StaticStar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StaticStar();

  double rating;

  StaticStar({required this.rating});
}

class _StaticStar extends State<StaticStar> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.rating,
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
      itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
      itemSize: 10,
      onRatingUpdate: (double value) {},
      updateOnDrag: false,
      ignoreGestures: true,
      unratedColor: Colors.grey.shade300,
    );
  }
}
