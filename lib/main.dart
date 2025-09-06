import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wear/wear.dart';
import 'package:http/http.dart' as http;

final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
const List<String> cities = ["Bengaluru", "Mumbai", "Goa"];
final _random = Random();
String city = cities[0];

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(const MainApp()); // Runs the app
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'What is Weather Today?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  // Fetching weather data asynchronously
                  future: fetchWeather(city, apiKey),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Display weather information if data is available
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Display weather icon
                            Image.network(
                              snapshot.data!.iconUrl,
                              height: 52,
                              width: 52,
                            ),
                            // Display weather condition
                            Text(
                              snapshot.data!.condition,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            // Display city name
                            Text(
                              city,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            // Display temperature
                            Text(
                              'Temperature: ${snapshot.data!.temperature}°C',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            // Button to refresh data with a random city
                            IconButton(
                              onPressed: () {
                                city = cities[_random.nextInt(cities.length)];
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.refresh,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Display an error message if data fetching fails
                      return Text("Error: ${snapshot.error}");
                    }
                    // Display a loading indicator while fetching data
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

class WeatherData {
  final String temperature;
  final String condition;
  final String iconUrl;

  WeatherData(this.temperature, this.condition, this.iconUrl);
}

Future<WeatherData> fetchWeather(String city, String apiKey) async {
  final response = await http.get(
    Uri.parse("http://api.weatherapi.com/v1/current.json?q=$city&key=$apiKey"),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return WeatherData(
      data["current"]["temp_c"].toString(),
      data["current"]["condition"]["text"].toString(),
      "https:${data["current"]["condition"]["icon"].toString()}",
    );
  } else {
    // Throw an exception if data fetching fails
    throw Exception("Failed to fetch weather data");
  }
}
