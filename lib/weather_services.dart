// lib/weather_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model.dart';

class WeatherService {
  final String apiKey = '1ccf1704fd09491480572248241106';
  final String apiUrl = 'http://api.weatherapi.com/v1/current.json';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse('$apiUrl?key=$apiKey&q=$cityName&aqi=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
