import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';

import '../models/weather_data.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WeatherData> _weatherFuture;

  @override
  Future<void> initState() async {
    super.initState();
    await LocationService.initialize();
    await _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    final position = LocationService.lastPosition;
    setState(() {
      _weatherFuture = WeatherService.fetchWeather(
        "${position?.latitude},${position?.longitude}",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlue.shade500, Colors.blue.shade200],
            ),
          ),
          child: WatchShape(
            builder: (context, shape, child) {
              return Center(
                child: FutureBuilder<WeatherData>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return WeatherDisplay(data: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
