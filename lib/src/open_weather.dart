import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meteo/src/api/api_geocoding.dart';
import 'package:meteo/src/api/api_weather.dart';
import 'package:meteo/src/weather_display.dart';
import 'package:meteo/src/weather_inputs.dart';

class OpenWeatherWidget extends StatefulWidget {
  const OpenWeatherWidget({super.key});

  @override
  _OpenWeatherWidgetState createState() => _OpenWeatherWidgetState();
}

class _OpenWeatherWidgetState extends State<OpenWeatherWidget> {
  late Future<Map<String, dynamic>> _weatherFuture;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    _weatherFuture = _loadCurrentWeather();
    FlutterNativeSplash.remove();
    super.initState();
  }

  Future<Map<String, dynamic>> _loadCurrentWeather() async {
    try {
      // Get current location
      final locationData = await Location().getCurrentPosition();
      final dynamic latitude = locationData['latitude'];
      final dynamic longitude = locationData['longitude'];

      // Fetch weather data
      final weatherData = await Weather().getCurrentWeather(
        latitude,
        longitude,
      );
      return weatherData;
    } catch (e) {
      throw Exception('Error loading location weather: $e');
    }
  }

  Future<void> _searchWeather(String city, String country) async {
    try {
      final weatherData = await Weather().searchWeather(city, country);
      setState(() {
        _weatherFuture = Future.value(weatherData);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error searching weather: $e');
      }
      // Handle error here, e.g., show error message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: WeatherDisplay(
                    future: _weatherFuture,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeatherInputs(
                cityController: _cityController,
                countryController: _countryController,
                onSearch: () {
                  final city = _cityController.text;
                  final country = _countryController.text;
                  _searchWeather(city, country);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
