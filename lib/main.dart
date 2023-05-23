import 'package:flutter/material.dart';
import 'package:muralhunt/providers/filter_provider.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => MuralProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
          fontFamily: 'Dancing Script '),
      home: const SplashScreen(),
    );
  }
}
