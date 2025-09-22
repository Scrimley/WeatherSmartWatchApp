import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:weather_app/screens/home_screen.dart';

import '../services/location_permission_service.dart';

class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Location permission is required to proceed.'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Retry requesting permission
              _retryPermissionRequest(context);
            },
            child: Text('Retry Permission Request'),
          ),
        ],
      ),
    );
  }

  Future<void> _retryPermissionRequest(BuildContext context) async {
    var status = await LocationPermissionService.checkLocationPermission();
    if (status == PermissionStatus.granted) {
      // Permission granted after retry, navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Permission still denied after retry
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required to proceed.')),
      );
    }
  }
}
