import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_modal.dart';
import 'toggle_filter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  late LocationData _locationData;
  Set<Marker> _markers = {};

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://donnees.montreal.ca/api/3/action/datastore_search?resource_id=f02401c2-8336-4086-9955-4c5592ace72e&limit=500'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result']['records'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;

    _controller
        .setMapStyle(await rootBundle.loadString('assets/map_style.json'));

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    fetchData().then((data) {
      setState(() {
        _markers = data.map((record) {
          return Marker(
            markerId: MarkerId(record['id']),
            position: LatLng(double.parse(record['latitude']),
                double.parse(record['longitude'])),
            icon: prefs.getString(record['id']) == null
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                builder: (builder) {
                  return BottomModal(
                    id: record['id'],
                    artiste: record['artiste'],
                    latitude: record['latitude'],
                    longitude: record['longitude'],
                    image: record['image'],
                  );
                },
              );
            },
          );
        }).toSet();
      });
    });
    await Location().getLocation().then((locationData) {
      setState(() {
        _locationData = locationData;
      });
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 15.0,
      )));
    });
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
            // buildingsEnabled: false,
            markers: _markers,
          ),
          const ToggleFilter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_locationData.latitude!, _locationData.longitude!),
              zoom: await _controller.getZoomLevel(),
            ),
          ));
        },
        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
    );
  }
}
