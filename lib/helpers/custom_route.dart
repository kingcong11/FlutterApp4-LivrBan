import 'package:flutter/material.dart';

// this can be used for on the fly navigation (push only not pushNamed)
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions
    // return super.buildTransitions(context, animation, secondaryAnimation, child);
    if (settings.name == '/') {
      return child;
    }

    return SlideTransition(
      position: Tween(
        begin: Offset(1.0, 0.0),
        end: Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions
    // return super.buildTransitions(context, animation, secondaryAnimation, child);
    if (route.settings.name == '/') {
      return child;
    }

    return SlideTransition(
      position: Tween(
        begin: Offset(1.0, 0.0),
        end: Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }
}
