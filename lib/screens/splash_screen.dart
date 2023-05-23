import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/screens/map_screen.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:muralhunt/utils/location.dart';
import 'package:muralhunt/utils/api.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Location.determinePosition().then((value) {
      API.getMurals().then((Iterable<Mural> murals) {
        context.read<MuralProvider>().setAll(murals);
        BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(10, 10),
          ),
          'lib/assets/Union.png',
        ).then((capturedIcon) {
          BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            'lib/assets/Union.png',
          ).then((uncapturedIcon) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MapScreen(
                      capturedIcon: capturedIcon,
                      uncapturedIcon: uncapturedIcon)),
            );
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/logo_red.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'MuralHunt',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}