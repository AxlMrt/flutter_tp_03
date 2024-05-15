import 'package:dio/dio.dart';
import 'package:meteo/src/api/api_geocoding.dart';
import 'package:meteo/src/common/keys/api_keys.dart';
import 'package:meteo/src/common/urls/api_urls.dart';

class Weather {
  final apiKey = APIKeys();

  Future<Map<String, dynamic>> getCurrentWeather(
      dynamic latitude, dynamic longitude) async {
    try {
      Dio dio = Dio();
      APIUrl url = APIUrl();

      Response response = await dio.get(url.weatherURL, queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': apiKey.weatherApiKey,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error retrieving weather: $e');
    }
  }

  Future<Map<String, dynamic>> searchWeather(
      String city, String country) async {
    try {
      final locationData =
          await Location().getLocationFromAddress(city, country);
      final dynamic latitude = locationData['latitude'];
      final dynamic longitude = locationData['longitude'];
      return getCurrentWeather(latitude, longitude);
    } catch (e) {
      throw Exception('Error searching weather: $e');
    }
  }
}
