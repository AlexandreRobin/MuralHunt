import 'package:flutter/material.dart';
import 'package:muralhunt/screen/splash_screen.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuralHunt',
      theme: ThemeData(
        primaryColor: Color(0xEE010000),
        primarySwatch: Colors.blue,
        fontFamily: 'Dancing Script '
      ),
      home: const SplashScreen(),
    );
  }
}
