import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/bottom_card.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:muralhunt/utils/location.dart';
import 'package:muralhunt/toggle_filter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.murals,
  });

  final Iterable<Mural> murals;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _centerCamera();
    _applyStyle();
  }

  Future<void> _centerCamera() async {
    final GoogleMapController controller = await _controller.future;
    final Position position = await Location.determinePosition();
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      ),
    ));
  }

  Future<void> _applyStyle() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .setMapStyle(await rootBundle.loadString('assets/map_style.json'));
  }

  _onFilter(Set<Marker> markers) async {
    await _controller.future;
    setState(() {
      _markers = markers;
    });
  }

  _onTapMarker(Mural mural) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      // isScrollControlled: true,
      builder: (builder) {
        return BottomCard(
          mural: mural,
        );
      },
    );
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
            markers: _markers,
          ),
          ToggleFilter(
            murals: widget.murals,
            onFilter: _onFilter,
            onTapMarker: _onTapMarker,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _centerCamera,
        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
    );
  }
}
