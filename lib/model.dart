

class Weather {
  final String cityName;
  final double temperature;
  final String description;

  Weather({required this.cityName, required this.temperature, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      description: json['current']['condition']['text'],
    );
  }
}
