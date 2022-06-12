import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/activity_overview.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/choose_outfit_button.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';
import 'package:what_to_wear/activity/widgets/location_widget.dart';
import 'package:what_to_wear/activity/widgets/start_date_widget.dart';
import 'package:what_to_wear/screens/user_activity_screen.dart';

typedef WeatherCallback = void Function(WeatherForecast? forecast);
typedef OutfitCallback = void Function(Outfit? outfit);
typedef OverviewCallback = void Function(ActivityOverview? overview);

class ActivityWidget extends StatefulWidget {
  ActivityWidget(
      {Key? key,
      required this.weatherCallback,
      required this.outfitCallback,
      required this.mode,
      this.modeCallback,
      this.overviewCallback})
      : super(key: key);
  final WeatherCallback weatherCallback;
  final OutfitCallback outfitCallback;
  ActivityMode mode;
  final ModeCallback? modeCallback;
  final OverviewCallback? overviewCallback;

  @override
  ActivityWidgetState createState() {
    return ActivityWidgetState();
  }
}

class ActivityWidgetState extends State<ActivityWidget> {
  DateTime _chosenDateTime = StartDateWidgetState.setStartDateTime();
  ActivityIntensity? _intensity = ActivityIntensity.medium;
  String _location = '';
  String _latitude = '';
  String _longitude = '';
  WeatherForecast? _forecast;
  Outfit? _outfit;

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
            callback: (latitude, longitude, location) => setState(() {
                  _latitude = latitude;
                  _longitude = longitude;
                  _location = location;
                  print('Ustawiono location w ActivityWidget: ' + _location);
                }),
            latitude: _latitude,
            longitude: _longitude,
            location: _location),
        ChooseOutfitButton(
          weatherCallback: (forecast) => setState(() {
            _forecast = forecast;
            widget.weatherCallback(_forecast);
          }),
          outfitCallback: (outfit) => setState(() {
            _outfit = outfit;
            widget.outfitCallback(_outfit);
          }),
          context: context,
          chosenDateTime: _chosenDateTime,
          intensity: _intensity,
          latitude: _latitude,
          longitude: _longitude,
          location: _location,
          mode: widget.mode,
          modeCallback: (ActivityMode mode) => setState(() {
            widget.mode = mode;
            widget.modeCallback!(widget.mode);
            widget.overviewCallback!(ActivityOverview(
                chosenDate: _chosenDateTime,
                location: _location,
                intensity: _intensity));
          }),
        ),
      ],
    );
  }
}
