import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import the shared_preferences package
import '../model.dart';
import '../weather_services.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();
  Weather? weather;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadLastCity();
  }

  Future<void> loadLastCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastCity = prefs.getString('lastCity');
    if (lastCity != null) {
      cityController.text = lastCity;
      fetchWeather(lastCity);
    }
  }

  Future<void> saveLastCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCity', city);
  }

  void fetchWeather([String? city]) async {
    setState(() {
      isLoading = true;
    });
    try {
      String cityName = city ?? cityController.text;
      Weather fetchedWeather = await weatherService.fetchWeather(cityName);
      await saveLastCity(cityName);
      setState(() {
        weather = fetchedWeather;
      });
    } catch (e) {
      // Handle error appropriately in a real app
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget getWeatherAnimation(String description) {
    String lowerDescription = description.toLowerCase();

    if (lowerDescription.contains('sun') || lowerDescription.contains('clear')) {
      return Lottie.asset('assets/Animation - 1718512333359.json');  // Sunny animation
    } else if (lowerDescription.contains('rain') || lowerDescription.contains('drizzle')) {
      return Lottie.asset('assets/Animation - 1718513312399.json');  // Rain animation
    } else if (lowerDescription.contains('cloud')) {
      return Lottie.asset('assets/cloudy.json');  // Cloudy animation
    } else if (lowerDescription.contains('snow')) {
      return Lottie.asset('assets/snow.json');  // Snow animation
    } else {
      return Container();  // Default case if no animation matches
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/1459.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 100), // Add space at the top
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => fetchWeather(),
                    ),
                  ),
                  style: TextStyle(color: Colors.black), // Text color inside the search bar
                ),
                SizedBox(height: 20),
                if (isLoading) CircularProgressIndicator(),
                if (weather != null) ...[
                  getWeatherAnimation(weather!.description),
                  Text(
                    weather!.cityName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    '${weather!.temperature}°C',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    weather!.description,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
