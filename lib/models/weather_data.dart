class WeatherData {
  final String location;
  final String temperature;
  final String condition;
  final String iconUrl;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json["location"]["name"].toString(),
      temperature: json["current"]["temp_c"].toString(),
      condition: json["current"]["condition"]["text"].toString(),
      iconUrl: "https:${json["current"]["condition"]["icon"].toString()}",
    );
  }
}
