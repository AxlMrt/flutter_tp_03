import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIKeys {
  final ninjaAPIKey = dotenv.env["NINJA_APIKEY"];
  final weatherApiKey = dotenv.env["OPENWEATHER_APIKEY"];
}
