// filepath: /Users/benglover/Repositories/WeatherSmartWatchApp/lib/widgets/weather_display.dart
import 'package:flutter/material.dart';
import '../models/weather_data.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherData data;

  const WeatherDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(data.iconUrl, height: 52, width: 52),
          Text(
            data.condition,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          Text(
            data.location,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'Temperature: ${data.temperature}°C',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
