import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001e31),
      body: Center(
        child: Image.asset('assets/loading_blue_circle.gif'),
      ),
    );
  }
}

