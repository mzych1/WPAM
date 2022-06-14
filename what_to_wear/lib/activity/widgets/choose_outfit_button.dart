import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/activity_overview.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';
import 'package:what_to_wear/screens/activity_details_screen.dart';
import 'package:what_to_wear/screens/user_activity_screen.dart';

typedef WeatherForecastCallback = void Function(WeatherForecast forecast);
typedef OutfitCallback = void Function(Outfit outfit);
typedef ModeCallback = void Function(
    ActivityMode mode, ActivityOverview overview);
final CollectionReference _activities =
    FirebaseFirestore.instance.collection('activities');

class ChooseOutfitButton extends StatelessWidget {
  ChooseOutfitButton(
      {Key? key,
      required this.weatherCallback,
      required this.outfitCallback,
      required this.context,
      required this.overview,
      required this.mode,
      required this.modeCallback})
      : super(key: key);

  final WeatherForecastCallback weatherCallback;
  final OutfitCallback outfitCallback;
  BuildContext context;
  ActivityOverview overview;
  ActivityMode mode;
  final ModeCallback modeCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ElevatedButton(
        onPressed: chooseOutfit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 10.0, bottom: 10.0),
              child: Text('Dobierz strój', style: TextStyle(fontSize: 24)),
            ),
            Image.asset(
              'assets/running_man.png',
              height: 40.0,
              width: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseOutfit() async {
    if (overview.latitude.isEmpty ||
        overview.longitude.isEmpty ||
        overview.location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nie wybrano lokalizacji'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
    } else {
      final difference = overview.chosenDate.difference(DateTime.now());
      if (difference.inMinutes < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Wybrana data i godzina nie może być wcześniejsza niż bieżąca pora'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3)),
        );
      } else {
        int forecastsCount = (difference.inHours / 3).floor() + 2;
        WeatherForecast forecast = await WeatherApiProvider()
            .getWeatherForecast(overview.latitude, overview.longitude,
                forecastsCount, overview.chosenDate);
        weatherCallback(forecast);
        Outfit outfit = Outfit(
            forecast.apparentTemperature,
            overview.intensity,
            forecast.cloudsPercentage,
            forecast.precipitationChance,
            overview.chosenDate.hour);
        outfitCallback(outfit);

        if (mode == ActivityMode.loggedOut) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityDetailsScreen(
                forecast: forecast,
                outfit: outfit,
                overview: overview,
              ),
            ),
          );
        } else if (mode == ActivityMode.add) {
          await _activities.add({
            "location": overview.location,
            "date": overview.chosenDate,
            "intensity": getIntensityName(overview.intensity),
            "longitude": overview.longitude,
            "latitude": overview.latitude,
            "weather_description": forecast.description,
            "temperature": forecast.temperature,
            "apparent_temperature": forecast.apparentTemperature,
            "wind": forecast.windSpeed,
            "clouds": forecast.cloudsPercentage,
            "weather_image_url": forecast.imageUrl,
            "precipitation_chance": forecast.precipitationChance,
            "running_apparent_temperature": outfit.runningApparentTemperature,
            "singlet": outfit.clothesMap[OutfitPartType.singlet]?.isUsed,
            "tshirt": outfit.clothesMap[OutfitPartType.tshirt]?.isUsed,
            "bluzka": outfit.clothesMap[OutfitPartType.bluzka]?.isUsed,
            "ortalion": outfit.clothesMap[OutfitPartType.ortalion]?.isUsed,
            "kurtka": outfit.clothesMap[OutfitPartType.kurtka]?.isUsed,
            "szorty": outfit.clothesMap[OutfitPartType.szorty]?.isUsed,
            "leginsy": outfit.clothesMap[OutfitPartType.leginsy]?.isUsed,
            "ocieplaneLeginsy":
                outfit.clothesMap[OutfitPartType.ocieplaneLeginsy]?.isUsed,
            "opaska": outfit.clothesMap[OutfitPartType.opaska]?.isUsed,
            "czapka": outfit.clothesMap[OutfitPartType.czapka]?.isUsed,
            "komin": outfit.clothesMap[OutfitPartType.komin]?.isUsed,
            "kaszkiet": outfit.clothesMap[OutfitPartType.kaszkiet]?.isUsed,
            "rekawiczki": outfit.clothesMap[OutfitPartType.rekawiczki]?.isUsed
          });
          print("overview: " + overview.toString());
          modeCallback(ActivityMode.details, overview);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Dodano aktywność'),
                duration: Duration(seconds: 1)),
          );
        } else if (mode == ActivityMode.edit) {
          print('ACTIVITY ID: ' + overview.activityId.toString());
          await _activities.doc(overview.activityId).update({
            "location": overview.location,
            "date": overview.chosenDate,
            "intensity": getIntensityName(overview.intensity),
            "longitude": overview.longitude,
            "latitude": overview.latitude,
            "weather_description": forecast.description,
            "temperature": forecast.temperature,
            "apparent_temperature": forecast.apparentTemperature,
            "wind": forecast.windSpeed,
            "clouds": forecast.cloudsPercentage,
            "weather_image_url": forecast.imageUrl,
            "precipitation_chance": forecast.precipitationChance,
            "running_apparent_temperature": outfit.runningApparentTemperature,
            "singlet": outfit.clothesMap[OutfitPartType.singlet]?.isUsed,
            "tshirt": outfit.clothesMap[OutfitPartType.tshirt]?.isUsed,
            "bluzka": outfit.clothesMap[OutfitPartType.bluzka]?.isUsed,
            "ortalion": outfit.clothesMap[OutfitPartType.ortalion]?.isUsed,
            "kurtka": outfit.clothesMap[OutfitPartType.kurtka]?.isUsed,
            "szorty": outfit.clothesMap[OutfitPartType.szorty]?.isUsed,
            "leginsy": outfit.clothesMap[OutfitPartType.leginsy]?.isUsed,
            "ocieplaneLeginsy":
                outfit.clothesMap[OutfitPartType.ocieplaneLeginsy]?.isUsed,
            "opaska": outfit.clothesMap[OutfitPartType.opaska]?.isUsed,
            "czapka": outfit.clothesMap[OutfitPartType.czapka]?.isUsed,
            "komin": outfit.clothesMap[OutfitPartType.komin]?.isUsed,
            "kaszkiet": outfit.clothesMap[OutfitPartType.kaszkiet]?.isUsed,
            "rekawiczki": outfit.clothesMap[OutfitPartType.rekawiczki]?.isUsed
          });

          modeCallback(ActivityMode.details, overview);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Zedytowano aktywność'),
                duration: Duration(seconds: 1)),
          );
        }
      }
    }
  }

  String getIntensityName(ActivityIntensity? intensity) {
    if (intensity == ActivityIntensity.low) {
      return "Niska";
    } else if (intensity == ActivityIntensity.high) {
      return "Wysoka";
    } else {
      return "Umiarkowana";
    }
  }
}
