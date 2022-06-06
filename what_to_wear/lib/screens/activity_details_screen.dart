import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/outfit_widget.dart';
import 'package:what_to_wear/activity/widgets/weather_widget.dart';

class ActivityDetailsScreen extends StatelessWidget {
  const ActivityDetailsScreen(
      {super.key, required this.forecast, required this.outfit});

  final WeatherForecast forecast;
  final Outfit outfit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pogoda i strój"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WeatherWidget(forecast: forecast),
              OutfitWidget(outfit: outfit),
            ],
          ),
        ),
      ),
    );
  }
}
