import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/weather_data.dart';
import '../utils/constants.dart';

class WeatherService {
  static final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  static Future<WeatherData> fetchWeather(String location) async {
    final response = await http.get(
      Uri.parse(
        "${AppConstants.weatherApiBaseUrl}/current.json?q=$location&key=$_apiKey",
      ),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch weather data: ${response.statusCode}");
    }
  }
}
