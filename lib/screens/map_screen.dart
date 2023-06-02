import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/providers/filter_provider.dart';
import 'package:muralhunt/providers/marker_provider.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:muralhunt/utils/location.dart';
import 'package:muralhunt/widget/filter_widget.dart';
import 'package:muralhunt/widget/score_widget.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _centerCamera();
    _applyStyle();
  }

  void _centerCamera() async {
    final GoogleMapController controller = await _controller.future;
    final Position position = await Location.determinePosition();
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      ),
    ));
  }

  void _applyStyle() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .setMapStyle(await rootBundle.loadString('lib/assets/map_style.json'));
  }

  Set<Marker> _setMarkers() {
    Iterable<Mural> murals = context.watch<MuralProvider>().murals;
    bool captured = context.watch<FilterProvider>().captured;
    bool notCaptured = context.watch<FilterProvider>().notCaptured;
    BitmapDescriptor capturedIcon =
        context.watch<MarkerProvider>().capturedIcon;
    BitmapDescriptor uncapturedIcon =
        context.watch<MarkerProvider>().uncapturedIcon;

    Set<Marker> markers = murals
        .where((mural) =>
            captured && mural.isCaptured || notCaptured && !mural.isCaptured)
        .map((mural) {
      return mural.createMarker(context, capturedIcon, uncapturedIcon);
    }).toSet();

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(45.50, -73.56),
              zoom: 10,
            ),
            onMapCreated: _onMapCreated,
            compassEnabled: false,
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                northeast: const LatLng(45.70, -73.47),
                southwest: const LatLng(45.40, -73.95))),
            mapToolbarEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(10, null),
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _setMarkers(),
          ),
          const FilterWidget(),
          const ScoreWidget()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _centerCamera,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SvgPicture.asset(
          'lib/assets/location_red.svg',
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}
