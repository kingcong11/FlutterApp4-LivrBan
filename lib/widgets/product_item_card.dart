import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Packages */
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Providers */
import '../providers/product_provider.dart';

/* Screens */
import '../screens/product_detail_screen.dart';

class ProductItemCard extends StatelessWidget {
  /* Properties */

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Product>(context);
    return LayoutBuilder(
      builder: (_, constraint) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: loadedProduct.id);
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 7,
                  offset: Offset(0, 0),
                )
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5),
                  Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          child: Image.asset(
                            loadedProduct.imageUrl,
                            fit: BoxFit.cover,
                            isAntiAlias: true,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 0,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).accentColor.withOpacity(.3),
                            child: IconButton(
                              icon: Icon(
                                (loadedProduct.isFavorite)
                                    ? Icons.favorite
                                    : FeatherIcons.heart,
                                size: 18,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                loadedProduct.toggleIsFavorite();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Container(
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF505050),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      (loadedProduct.isFavorite)
                                          ? 'Added to Wishlist.'
                                          : 'Removed Wishlist.',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  duration: Duration(milliseconds: 2300),
                                  elevation: 0,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                ));
                              },
                            ),
                          ),
                        )
                      ],
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 10),
                                child: Text(
                                  loadedProduct.title,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, right: 12),
                                child: FittedBox(
                                  child: Text(
                                    '\$ ${loadedProduct.price}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
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
          ),
        );
      },
    );
  }
}
