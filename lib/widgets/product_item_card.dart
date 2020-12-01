import 'package:flutter/material.dart';
import 'package:livrban/providers/authentication_service.dart';
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
    final scaffold = Scaffold.of(context);
    final auth = Provider.of<AuthenticationService>(context, listen: false);

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
                          child: Hero(
                            tag: loadedProduct.id,
                            child: FadeInImage(
                              placeholder: AssetImage(
                                'assets/images/default-placeholder-image.png',
                              ),
                              image: AssetImage(
                                loadedProduct.imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
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
                              onPressed: () async {
                                scaffold.showSnackBar(SnackBar(
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
                                          ? 'Removed from Wishlist.'
                                          : 'Added to Wishlist.',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  duration: Duration(milliseconds: 2300),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ));
                                try {
                                  await loadedProduct.toggleIsFavorite(
                                      auth.token, auth.userId);
                                } catch (error) {
                                  scaffold.hideCurrentSnackBar();
                                  scaffold.showSnackBar(SnackBar(
                                    content: Container(
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF505050),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(error.toString()),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    duration: Duration(milliseconds: 2300),
                                    elevation: 0,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                  ));

                                  // print(error.toString());

                                }
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
                                padding:
                                    const EdgeInsets.only(bottom: 8, right: 12),
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
