import 'package:flutter/material.dart';

/* Packages */
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

/* Helpers */
import './helpers/custom_route.dart';

/* Providers */
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/authentication_service.dart';

/* Screens */
import './screens/product_detail_screen.dart';
import './screens/homepage_screen.dart';
import './screens/my_bag_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/errorScreen.dart';
import './screens/intro_screen.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthenticationService()),
        ChangeNotifierProxyProvider<AuthenticationService, Products>(
          create: null,
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            (previousProducts == null) ? [] : previousProducts.getAllProducts,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<AuthenticationService, Orders>(
          create: null,
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            (previousOrders == null) ? [] : previousOrders.getAllOrders,
          ),
        ),
      ],
      child: Consumer<AuthenticationService>(
        builder: (context, authService, _) => MaterialApp(
          title: 'LivrBan',
          theme: ThemeData(
            primarySwatch: createMaterialColor(Color(0xFF174378)),
            brightness: Brightness.light,
            fontFamily: 'Rockford Sans',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                // TargetPlatform.android: CustomPageTransitionBuilder(),
                // TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }
            )
          ),
          debugShowCheckedModeBanner: false,
          home: (authService.isAuthenticated)
              ? HomePageScreen()
              : FutureBuilder(
                  future: authService.tryAutoLogin(),
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return IntroScreen();
                    } else if (dataSnapshot.hasError) {
                      return ErrorScreen();
                    } else {
                      return AuthScreen();
                    }
                  },
                ),
          routes: {
            HomePageScreen.routeName: (ctx) => HomePageScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            MyBagScreen.routeName: (ctx) => MyBagScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
