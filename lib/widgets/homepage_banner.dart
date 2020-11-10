import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomepageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(FeatherIcons.chevronLeft, color: Colors.white, size: 28),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(
                    'Aesthetic Chair',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(
                    'This Catie Uphostered Panel Bed defines basics made beautifully.',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            child: Stack(
              overflow: Overflow.clip,
              children: [
                Positioned(
                  top: -15,
                  right: -30,
                  height: 230,
                  width: 230,
                  child: Image.asset(
                    'assets/images/products/homepagebanner.png',
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
