import 'package:flutter/material.dart';

class HomepageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 56),
        child: LayoutBuilder(
          builder: (ctx, constraints) => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: constraints.maxWidth * 0.5,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        'This Catie Uphostered Panel Bed defines basics made beautifully. this is a sample passage to make this text very long lorem ipsum lorem ipsum ipsum lorem ipsum ipsum lorem ipsum',
                        overflow: TextOverflow.fade,
                        maxLines: 6,
                        softWrap: true,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: constraints.maxWidth * .5,
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
            ],
          ),
        ),
      ),
    );
  }
}
