import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class MyCustomRatingBar extends StatelessWidget {
  const MyCustomRatingBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.centerLeft,
      child: RatingBar.builder(
        initialRating: 3.5,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding:
            EdgeInsets.symmetric(horizontal: 1),
        itemSize: 100,
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Theme.of(context).accentColor,
          size: 10,
        ),
        onRatingUpdate: null,
      ),
    );
  }
}