import 'package:flutter/material.dart';

import 'package:location/location.dart';

import 'screens/home_screen.dart';
import 'screens/permission_denied_screen.dart';
import 'services/location_permission_service.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: WeatherAppWidget());
  }
}

class WeatherAppWidget extends StatefulWidget {
  const WeatherAppWidget({super.key});

  @override
  _WeatherAppWidgetState createState() => _WeatherAppWidgetState();
}

class _WeatherAppWidgetState extends State<WeatherAppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Smart Watch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<PermissionStatus>(
        future: LocationPermissionService.checkLocationPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future is still loading, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else {
            // Future is complete, check the permission status
            if (snapshot.data == PermissionStatus.granted) {
              // Permission granted, allow the user to proceed
              return const HomeScreen();
            } else {
              // Permission denied, show a message or request again
              return PermissionDeniedScreen();
            }
          }
        },
      ),
    );
  }
}
