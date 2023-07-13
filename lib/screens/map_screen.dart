import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/providers/filter_provider.dart';
import 'package:muralhunt/providers/map_provider.dart';
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
  static const LatLng limitNortheast = LatLng(45.7, -73.5);
  static const LatLng limitSouthwest = LatLng(45.4, -73.8);
  static const LatLng intialPosition = LatLng(45.50, -73.57);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool _myLocationEnabled = false;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _centerCameraOnLocation();
    _applyStyle();
  }

  void _applyStyle() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .setMapStyle(await rootBundle.loadString('lib/assets/map_style.json'));
  }

  void _centerCameraOnTarget(LatLng target) async {
    context.read<MapProvider>().setPadding(const EdgeInsets.only(bottom: 150));
    final GoogleMapController controller = await _controller.future;
    await Future.delayed(const Duration(milliseconds: 50));
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: target,
        zoom: 17,
      ),
    ));
    context.read<MapProvider>().setPadding(const EdgeInsets.only(bottom: 1000));
  }

  void _centerCameraOnLocation() async {
    context.read<MapProvider>().setPadding(const EdgeInsets.only(bottom: 0));
    final GoogleMapController controller = await _controller.future;
    final Position position = await Location.determinePosition();
    await Future.delayed(const Duration(milliseconds: 50));
    double zoom = 17;
    LatLng target = LatLng(position.latitude, position.longitude);
    _myLocationEnabled = true;

    if (position.latitude <= limitSouthwest.latitude ||
        position.latitude >= limitNortheast.latitude ||
        position.longitude <= limitSouthwest.longitude ||
        position.longitude >= limitNortheast.longitude) {
      target = intialPosition;
      zoom = 14;
      _myLocationEnabled = false;
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: target,
        zoom: zoom,
      ),
    ));
    context.read<MapProvider>().setPadding(const EdgeInsets.only(bottom: 1000));
  }

  Set<Marker> _setMarkers() {
    List<Mural> murals = context.watch<MuralProvider>().murals;
    bool captured = context.watch<FilterProvider>().captured;
    bool notCaptured = context.watch<FilterProvider>().notCaptured;
    BitmapDescriptor capturedIcon = context.watch<MapProvider>().capturedIcon;
    BitmapDescriptor uncapturedIcon =
        context.watch<MapProvider>().uncapturedIcon;

    Set<Marker> markers = murals
        .where((mural) =>
            captured && mural.isCaptured || notCaptured && !mural.isCaptured)
        .map((mural) {
      return mural.createMarker(
          context, capturedIcon, uncapturedIcon, _centerCameraOnTarget);
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
              target: intialPosition,
              zoom: 14,
            ),
            onMapCreated: _onMapCreated,
            compassEnabled: false,
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                northeast: limitNortheast,
                southwest: limitSouthwest,
              ),
            ),
            mapToolbarEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(11, null),
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: false,
            markers: _setMarkers(),
            padding: context.watch<MapProvider>().padding,
          ),
          const FilterWidget(),
          const ScoreWidget()
        ],
      ),
      floatingActionButton: _myLocationEnabled
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _centerCameraOnLocation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(
                'lib/assets/location_red.svg',
                width: 22,
                height: 22,
              ),
            )
          : Container(),
    );
  }
}
