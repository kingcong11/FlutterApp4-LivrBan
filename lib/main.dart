import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Providers */
import './providers/products_provider.dart';
import './providers/cart_provider.dart';

/* Screens */
import './screens/product_detail_screen.dart';
import './screens/homepage_screen.dart';
import './screens/my_bag_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
      ],
      child: MaterialApp(
        title: 'LivrBan',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Color(0xFFeb8440),
          fontFamily: 'Rockford Sans',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (ctx) => HomePageScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          MyBagScreen.routeName: (ctx) => MyBagScreen(),
        },
      ),
    );
  }
}
