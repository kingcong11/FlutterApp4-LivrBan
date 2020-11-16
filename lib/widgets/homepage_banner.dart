import 'package:flutter/material.dart';

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
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(
                    'Aesthetic Living',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(
                      'This Catie Uphostered Panel Bed defines basics made beautifully. this is a sample passage to make this text very long',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                )
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
