import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteo/src/common/keys/api_keys.dart';
import 'package:meteo/src/common/urls/api_urls.dart';

class Location {
  final apiKey = APIKeys();
  APIUrl url = APIUrl();

  Future<Map<String, dynamic>> getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final dynamic latitude = position.latitude;
      final dynamic longitude = position.longitude;

      return {
        'latitude': latitude,
        'longitude': longitude,
      };
    } catch (e) {
      throw Exception('Error retrieving location: $e');
    }
  }

  Future<Map<String, dynamic>> getLocationFromAddress(
      String city, String country) async {
    try {
      Dio dio = Dio();
      dio.options.headers['X-Api-Key'] = apiKey.ninjaAPIKey;

      Response response = await dio.get(url.ninjaURL, queryParameters: {
        'city': city,
        'country': country,
      });

      if (response.statusCode == 200) {
        final data = response.data[0];
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error retrieving location: $e');
    }
  }
}
