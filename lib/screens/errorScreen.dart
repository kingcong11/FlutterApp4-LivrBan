import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            'Error Screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
