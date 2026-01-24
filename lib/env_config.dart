// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:weather_app/constants.dart';

class EnvConfig {
  static String WEATHER_API_KEY = const String.fromEnvironment(
    ENV_WEATHER_API_KEY,
    defaultValue: '',
  );
}
