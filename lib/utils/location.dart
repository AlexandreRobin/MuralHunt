import 'package:geolocator/geolocator.dart';
import 'package:muralhunt/utils/mural.dart';

class Location {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<bool> isCapturable(Mural mural) async {
    Position position = await Location.determinePosition();

    double bearing = Geolocator.distanceBetween(
        position.latitude, position.longitude, mural.latitude, mural.longitude);

    return bearing < 100;
  }
}
