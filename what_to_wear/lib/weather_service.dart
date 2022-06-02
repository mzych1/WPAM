import 'dart:convert';

import 'package:http/http.dart';

import 'auth/secrets.dart';

class WeatherForecast {
  late num temperature;
  late String description;
  late String iconId;
  late num cloudsPercentage; // 0-100
  late num windSpeed; // m/s
  late num precipitationChance; // 0-1
  late DateTime forecastDate; // polish time zone (GMT+2)

  WeatherForecast(
      {required this.temperature,
      required this.description,
      required this.iconId,
      required this.cloudsPercentage,
      required this.windSpeed,
      required this.precipitationChance,
      required this.forecastDate});

  WeatherForecast.fromJson(var jsonForecast) {
    temperature = jsonForecast['main']['temp'];
    description = jsonForecast['weather'][0]['description'];
    iconId = jsonForecast['weather'][0]['icon'];
    cloudsPercentage = jsonForecast['clouds']['all'];
    windSpeed = jsonForecast['wind']['speed'];
    precipitationChance = jsonForecast['pop'];
    forecastDate =
        DateTime.parse(jsonForecast['dt_txt']).add(const Duration(hours: 2));
  }

  @override
  String toString() {
    return 'WeatherForecast(temperature: $temperature, description: $description, iconId: $iconId, cloudsPercentage: $cloudsPercentage, ' +
        'windSpeed: $windSpeed, precipitationChance: $precipitationChance, forecastDate: $forecastDate)';
  }
}

class WeatherApiProvider {
  final client = Client();

  Future<WeatherForecast> getWeatherForecast(String latitude, String longitude,
      int forecastsCount, DateTime chosenDateTime) async {
    final weatherRequest = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&cnt=$forecastsCount&appid=$weatherApiKey&units=metric&lang=pl');
    final weatherResponse = await client.get(weatherRequest);

    if (weatherResponse.statusCode == 200) {
      final result = json.decode(weatherResponse.body);
      final forecastsList = result['list'];
      DateTime chosenDateUTC =
          chosenDateTime.subtract(const Duration(hours: 2));
      int minDifference = 24 * 60; // number of minutes in a day
      var chosenForecast;

      for (var forecast in forecastsList) {
        DateTime forecastDate = DateTime.parse(forecast['dt_txt']);
        final difference =
            chosenDateUTC.difference(forecastDate).inMinutes.abs();
        if (difference <= minDifference) {
          minDifference = difference;
          chosenForecast = forecast;
        }
      }
      WeatherForecast forecast = WeatherForecast.fromJson(chosenForecast);
      return forecast;
    } else {
      throw Exception('Failed to get weather forecasts');
    }
  }
}
