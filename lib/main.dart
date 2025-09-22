import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    await LocationService.initialize();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }
  runApp(const WeatherApp());
}
