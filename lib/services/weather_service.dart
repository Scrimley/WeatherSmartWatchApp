import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../env_config.dart';
import '../models/weather_data.dart';

class WeatherService {
  static Future<WeatherData> fetchWeather(String location) async {
    final response = await http.get(
      Uri.parse(
        "$WEATHER_API_URL/current.json?q=$location&key=${EnvConfig.WEATHER_API_KEY}",
      ),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch weather data: ${response.statusCode}");
    }
  }
}
