import 'package:dl_app/splashscreen.dart';
import 'package:flutter/material.dart';
void main()
{
  runApp(MlApp());
}

class MlApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );

  }
}