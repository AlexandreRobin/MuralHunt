import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/providers/map_provider.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/screens/map_screen.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:muralhunt/utils/location.dart';
import 'package:muralhunt/utils/api.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Location.determinePosition().then((value) {
      API.getMurals().then((List<Mural> murals) {
        context.read<MuralProvider>().setAll(murals);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MapScreen()));
      });
    });

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(0, 0)),
            'lib/assets/captured_filled_marker_red.png')
        .then((capturedIcon) {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(0, 0)),
              'lib/assets/uncaptured_marker_filled_grey.png')
          .then((uncapturedIcon) {
        context.read<MapProvider>().setMarkers(capturedIcon, uncapturedIcon);
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
            Image.asset(
              'lib/assets/logo_red.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Mural Hunt',
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
