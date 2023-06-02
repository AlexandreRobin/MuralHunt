import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerProvider with ChangeNotifier {
  BitmapDescriptor _capturedIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _uncapturedIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor get capturedIcon => _capturedIcon;
  BitmapDescriptor get uncapturedIcon => _uncapturedIcon;

  void setMarkers(BitmapDescriptor capturedIcon, BitmapDescriptor uncapturedIcon) {
    _capturedIcon = capturedIcon;
    _uncapturedIcon = uncapturedIcon;
    notifyListeners();
  }

}
