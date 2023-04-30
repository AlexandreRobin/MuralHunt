import 'package:flutter/material.dart';
import 'package:muralhunt/map_screen.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:muralhunt/utils/location.dart';
import 'package:muralhunt/utils/api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Location.determinePosition();
    API.getMurals().then((Iterable<Mural> murals) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapScreen(murals: murals)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Placeholder'),
    );
  }
}
