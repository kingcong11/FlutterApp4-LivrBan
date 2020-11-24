import 'package:flutter/material.dart';

/* packages */
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:livrban/screens/orders_screen.dart';

/* Screens */
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  final double statusBarSize;

  MainDrawer(this.statusBarSize);

  /* Builders */
  Widget listileBuilder(String title, IconData icon, Function callbackHandler,
      BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: callbackHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: statusBarSize),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.6),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Text(
                'LivrBan',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            listileBuilder(
              'Home',
              FeatherIcons.home,
              () => Navigator.of(context).pushReplacementNamed('/'),
              context,
            ),
            Divider(),
            listileBuilder(
              'Orders',
              FeatherIcons.package,
              () => Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName),
              context,
            ),
            Divider(),
            listileBuilder(
              'Products',
              Icons.vibration,
              () => Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName),
              context,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
