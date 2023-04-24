import 'package:flutter/material.dart';

import 'map_screen.dart';
import 'my_home_page.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuralHunt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Mural Hunt'),
      home: MapScreen(),
    );
  }
}
