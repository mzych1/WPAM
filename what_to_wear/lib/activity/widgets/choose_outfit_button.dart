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
typedef ModeCallback = void Function(ActivityMode mode);
final CollectionReference _activities =
    FirebaseFirestore.instance.collection('activities');

class ChooseOutfitButton extends StatelessWidget {
  ChooseOutfitButton(
      {Key? key,
      required this.weatherCallback,
      required this.outfitCallback,
      required this.context,
      required this.chosenDateTime,
      required this.intensity,
      required this.latitude,
      required this.longitude,
      required this.location,
      required this.mode,
      required this.modeCallback})
      : super(key: key);

  final WeatherForecastCallback weatherCallback;
  final OutfitCallback outfitCallback;
  BuildContext context;
  DateTime chosenDateTime;
  ActivityIntensity? intensity;
  String latitude;
  String longitude;
  String location;
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
    if (latitude.isEmpty || longitude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nie wybrano lokalizacji'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
    } else {
      final difference = chosenDateTime.difference(DateTime.now());
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
            .getWeatherForecast(
                latitude, longitude, forecastsCount, chosenDateTime);
        weatherCallback(forecast);
        Outfit outfit = Outfit(
            forecast.apparentTemperature,
            intensity,
            forecast.cloudsPercentage,
            forecast.precipitationChance,
            chosenDateTime.hour);
        outfitCallback(outfit);

        ActivityOverview overview = ActivityOverview(
            chosenDate: chosenDateTime,
            location: location,
            intensity: intensity);

        print("FORECAST: " + forecast.toString());
        print("CHOSEN_DATE_TIME: " + chosenDateTime.toString());
        print("INTENSITY: " + intensity.toString());
        print("LAT: " + latitude);
        print("LONG: " + longitude);
        print("OUTFIT: " + outfit.toString());
        print("MODE: " + mode.toString());

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
          await _activities.add({"location": location, "date": chosenDateTime});
          modeCallback(ActivityMode.details);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Dodano aktywność - TODO'),
                duration: Duration(seconds: 1)),
          );
        } else if (mode == ActivityMode.edit) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Zedytowano aktywność - TODO'),
                duration: Duration(seconds: 1)),
          );
        }
      }
    }
  }
}
