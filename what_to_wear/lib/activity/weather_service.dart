import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:what_to_wear/auth/secrets.dart';

class WeatherForecast {
  late num temperature;
  late num apparentTemperature;
  late String description;
  late String imageUrl;
  late num cloudsPercentage; // 0-100
  late num windSpeed; // m/s
  late num precipitationChance; // 0-100
  // late DateTime forecastDate; // polish time zone (GMT+2)

  WeatherForecast.fromJson(var jsonForecast) {
    temperature = jsonForecast['main']['temp'];
    apparentTemperature = jsonForecast['main']['feels_like'];
    description = jsonForecast['weather'][0]['description'];
    description =
        description[0].toUpperCase() + description.substring(1).toLowerCase();
    String iconId = jsonForecast['weather'][0]['icon'].toString();
    imageUrl =
        "https://openweathermap.org/img/wn/" + iconId.toString() + "@2x.png";
    cloudsPercentage = jsonForecast['clouds']['all'];
    windSpeed = jsonForecast['wind']['speed'];
    precipitationChance = jsonForecast['pop'] * 100;
    // forecastDate =
    //     DateTime.parse(jsonForecast['dt_txt']).add(const Duration(hours: 2));
  }

  WeatherForecast.fromSnapshot(DocumentSnapshot snapshot) {
    temperature = snapshot['temperature'] as num;
    apparentTemperature = snapshot['apparent_temperature'] as num;
    description = snapshot['weather_description'];
    imageUrl = snapshot['weather_image_url'];
    cloudsPercentage = snapshot['clouds'] as num;
    windSpeed = snapshot['wind'] as num;
    precipitationChance = snapshot['precipitation_chance'] as num;
  }

  @override
  String toString() {
    return 'WeatherForecast(temperature: $temperature, apparentTemperature: $apparentTemperature, description: $description, iconId: $imageUrl, cloudsPercentage: $cloudsPercentage, ' +
        'windSpeed: $windSpeed, precipitationChance: $precipitationChance)';
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
