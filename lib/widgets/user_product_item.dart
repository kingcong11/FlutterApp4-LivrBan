import 'package:flutter/material.dart';

/* Packages */
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

/* Providers */
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

/* Screens */
import '../screens/edit_product_screen.dart';

enum productAction { edit, delete }

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                      RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black54, fontSize: 13),
                            children: [
                              TextSpan(text: 'Item code: '),
                              TextSpan(
                                text: product.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(.8),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  Positioned(
                    right: -16,
                    top: -12,
                    child: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      icon: Icon(FeatherIcons.moreHorizontal),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          height: 15,
                          child: Row(
                            children: [
                              Text('Edit'),
                              Spacer(),
                              Icon(
                                FeatherIcons.layers,
                                size: 15,
                                color: Theme.of(context).accentColor,
                              ),
                            ],
                          ),
                          value: productAction.edit,
                        ),
                        PopupMenuItem(
                          height: 15,
                          child: Row(
                            children: [
                              Text('Delete'),
                              Spacer(),
                              Icon(
                                FeatherIcons.trash,
                                size: 15,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          value: productAction.delete,
                        ),
                      ],
                      onSelected: (selectedValue) async {
                        switch (selectedValue) {
                          case productAction.edit:
                            Navigator.of(context).pushNamed(
                                EditProductScreen.routeName,
                                arguments: product.id);
                            break;
                          case productAction.delete:
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).errorColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Item Deleted.',
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
                              await Provider.of<Products>(context,
                                      listen: false)
                                  .deleteProduct(product.id);
                            } catch (error){ }
                            break;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
