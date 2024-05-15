import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherDisplay extends StatelessWidget {
  final Future<Map<String, dynamic>> future;

  const WeatherDisplay({
    super.key,
    required this.future,
  });

  double kelvinToCelsius(double kelvin) {
    double celsius = kelvin - 273.15;
    return double.parse(celsius.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ],
            ),
          );
        } else {
          final dynamic weatherDescription =
              snapshot.data!['weather'][0]['description'];
          final dynamic cityName = snapshot.data!['name'];
          final dynamic temperature = snapshot.data!['main']['temp'];
          final iconCode = snapshot.data!["weather"][0]["icon"];
          final iconUrl = 'http://openweathermap.org/img/w/$iconCode.png';
          DateTime now = DateTime.now();

          String formattedDate = DateFormat('EEEE, d MMMM').format(now);
          return Column(
            children: [
              Column(
                children: [
                  Image.network(iconUrl),
                  Text('$weatherDescription'),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(formattedDate)),
              const SizedBox(height: 100.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${kelvinToCelsius(temperature)} °C',
                    style: const TextStyle(
                        fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                  Text('$cityName', style: const TextStyle(fontSize: 25.0)),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
