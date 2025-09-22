import 'package:geolocator/geolocator.dart';

class LocationService {
  static Position? _lastPosition;

  static Future<void> initialize() async {
    _lastPosition = await getLastKnownPosition();
  }

  static Position? get lastPosition => _lastPosition;

  static Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    _lastPosition = await Geolocator.getCurrentPosition();
    return _lastPosition;
  }
}
