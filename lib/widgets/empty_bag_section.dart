import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Screens */
import '../screens/homepage_screen.dart';

class EmptyBagSection extends StatelessWidget {
  const EmptyBagSection({
    Key key,
    @required this.availableContentSize,
  }) : super(key: key);

  final double availableContentSize;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: availableContentSize * .2),
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(.3),
              shape: BoxShape.circle,
            ),
            child: Icon(FeatherIcons.shoppingBag, size: 100, color: Theme.of(context).accentColor,),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Continue Shopping and add Items to your Bag!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          FlatButton(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.of(context).pushReplacementNamed(HomePageScreen.routeName),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          )
        ],
      );
  }
}