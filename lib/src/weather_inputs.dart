import 'package:flutter/material.dart';

class WeatherInputs extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController countryController;
  final VoidCallback onSearch;

  const WeatherInputs({
    super.key,
    required this.cityController,
    required this.countryController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: cityController,
          decoration: const InputDecoration(labelText: 'City'),
        ),
        TextField(
          controller: countryController,
          decoration: const InputDecoration(labelText: 'Country'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ElevatedButton(
            onPressed: onSearch,
            child: const Text('Search'),
          ),
        )
      ],
    );
  }
}
