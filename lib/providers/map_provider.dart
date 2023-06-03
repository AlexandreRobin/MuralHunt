import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/utils/location.dart';
import 'package:muralhunt/utils/mural.dart';

class MapProvider with ChangeNotifier {
  BitmapDescriptor _capturedIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _uncapturedIcon = BitmapDescriptor.defaultMarker;
  EdgeInsets _padding = const EdgeInsets.only(bottom: 1000, left: 0);
  bool _isCapturable = false;

  BitmapDescriptor get capturedIcon => _capturedIcon;
  BitmapDescriptor get uncapturedIcon => _uncapturedIcon;
  EdgeInsets get padding => _padding;
  bool get isCapturable => _isCapturable;

  void setMarkers(
      BitmapDescriptor capturedIcon, BitmapDescriptor uncapturedIcon) {
    _capturedIcon = capturedIcon;
    _uncapturedIcon = uncapturedIcon;
    notifyListeners();
  }

  void setPadding(EdgeInsets padding) {
    _padding = padding;
    notifyListeners();
  }

  Future<void> setCapturable(Mural mural) async {
    _isCapturable = await Location.isCapturable(mural);
    notifyListeners();
  }
}
