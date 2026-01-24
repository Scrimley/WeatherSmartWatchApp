import 'package:location/location.dart';

class LocationPermissionService {
  static final Location _location = Location();

  // Check and request location permissions
  static Future<PermissionStatus> checkLocationPermission() async {
    var serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // Location service is still not enabled
        return PermissionStatus.denied;
      }
    }

    var status = await _location.hasPermission();
    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();
    }

    return status;
  }

  // Get current location
  static Future<LocationData?> getCurrentLocation() async {
    PermissionStatus status = await checkLocationPermission();

    if (status == PermissionStatus.granted) {
      return await _location.getLocation();
    }

    return null;
  }

  // Get location updates stream
  static Stream<LocationData> getLocationStream() {
    _location.enableBackgroundMode(enable: true);
    return _location.onLocationChanged;
  }
}
