import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/choose_outfit_button.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';
import 'package:what_to_wear/activity/widgets/location_widget.dart';
import 'package:what_to_wear/activity/widgets/start_date_widget.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({Key? key}) : super(key: key);

  @override
  ActivityWidgetState createState() {
    return ActivityWidgetState();
  }
}

class ActivityWidgetState extends State<ActivityWidget> {
  DateTime _chosenDateTime = StartDateWidgetState.setStartDateTime();
  ActivityIntensity? _intensity = ActivityIntensity.medium;
  String _latitude = '';
  String _longitude = '';
  WeatherForecast? _forecast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StartDateWidget(
          callback: (dateTime) => setState(() => _chosenDateTime = dateTime),
          chosenDateTime: _chosenDateTime,
        ),
        const SizedBox(
          height: 20,
        ),
        IntensityWidget(
          callback: (intensity) => setState(() => _intensity = intensity),
          intensity: _intensity,
        ),
        const SizedBox(
          height: 20,
        ),
        LocationWidget(
            callback: (latitude, longitude) => setState(() {
                  _latitude = latitude;
                  _longitude = longitude;
                }),
            latitude: _latitude,
            longitude: _longitude),
        ChooseOutfitButton(
          callback: (forecast) => setState(() => _forecast = forecast),
          context: context,
          chosenDateTime: _chosenDateTime,
          intensity: _intensity,
          latitude: _latitude,
          longitude: _longitude,
        ),
      ],
    );
  }
}