import 'package:flutter/material.dart';

class ProductItemCard extends StatelessWidget {
  /* Properties */

  final String id;
  final String title;
  final double price;
  final String imageUrl;

  ProductItemCard({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 7,
                  offset: Offset(0, 0),
                )
              ]
            ),
            child: Column(
              children: [
                SizedBox(height: 5),
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: Container(
                    // color: Colors.red,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.fill,
                      isAntiAlias: true,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            // color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: Text(
                                title,
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                // overflow: TextOverflow.,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8, right: 12),
                              child: FittedBox(
                                child: Text(
                                  '\$ $price',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.lightGreen),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
