import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';

typedef OutfitButtonCallback = void Function(WeatherForecast forecast);

class ChooseOutfitButton extends StatelessWidget {
  ChooseOutfitButton(
      {Key? key,
      required this.callback,
      required this.context,
      required this.chosenDateTime,
      required this.intensity,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  final OutfitButtonCallback callback;
  BuildContext context;
  DateTime chosenDateTime;
  ActivityIntensity? intensity;
  String latitude;
  String longitude;

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
        callback(forecast);

        print("FORECAST: " + forecast.toString());
        print("CHOSEN_DATE_TIME: " + chosenDateTime.toString());
        print("INTENSITY: " + intensity.toString());
        print("LAT: " + latitude);
        print("LONG: " + longitude);
      }
    }
  }
}
