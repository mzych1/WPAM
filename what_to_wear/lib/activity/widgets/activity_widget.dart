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
      : super(key: key) {
    print("Tworzenie nowego overview");
    overview = ActivityOverview(
      chosenDate: StartDateWidgetState.setStartDateTime(),
      intensity: ActivityIntensity.medium,
      location: '',
      latitude: '',
      longitude: '',
    );
  }

  // ActivityWidget tworzony na potrzeby edycji
  ActivityWidget.withStartData(
      {Key? key,
      required this.weatherCallback,
      required this.outfitCallback,
      required this.mode,
      required this.modeCallback,
      required this.overviewCallback,
      overview})
      : super(key: key) {
    if (overview == null) {
      this.overview = ActivityOverview(
        chosenDate: StartDateWidgetState.setStartDateTime(),
        intensity: ActivityIntensity.medium,
        location: '',
        latitude: '',
        longitude: '',
      );
    } else {
      this.overview = overview;
    }
  }

  final WeatherCallback weatherCallback;
  final OutfitCallback outfitCallback;
  ActivityMode mode;
  final ModeCallback? modeCallback;
  final OverviewCallback? overviewCallback;
  late ActivityOverview overview;

  @override
  ActivityWidgetState createState() {
    return ActivityWidgetState();
  }
}

class ActivityWidgetState extends State<ActivityWidget> {
  WeatherForecast? _forecast;
  Outfit? _outfit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StartDateWidget(
          callback: (dateTime) =>
              setState(() => widget.overview.chosenDate = dateTime),
          chosenDateTime: widget.overview.chosenDate,
        ),
        const SizedBox(
          height: 20,
        ),
        IntensityWidget(
          callback: (intensity) =>
              setState(() => widget.overview.intensity = intensity),
          intensity: widget.overview.intensity,
        ),
        const SizedBox(
          height: 20,
        ),
        LocationWidget(
            callback: (latitude, longitude, location) => setState(() {
                  widget.overview.latitude = latitude;
                  widget.overview.longitude = longitude;
                  widget.overview.location = location;
                  print("ACTIVIY_WIDGET OVERVIEW callback: " +
                      widget.overview.toString());
                }),
            latitude: widget.overview.latitude,
            longitude: widget.overview.longitude,
            location: widget.overview.location),
        ChooseOutfitButton(
          weatherCallback: (forecast) => setState(() {
            _forecast = forecast;
            widget.weatherCallback(_forecast);
            print("ACTIVIY_WIDGET OVERVIEW weatherCallback: " +
                widget.overview.toString());
          }),
          outfitCallback: (outfit) => setState(() {
            _outfit = outfit;
            widget.outfitCallback(_outfit);
            print("ACTIVIY_WIDGET OVERVIEW outfitCallback: " +
                widget.overview.toString());
          }),
          context: context,
          overview: widget.overview,
          mode: widget.mode,
          modeCallback: (ActivityMode mode, ActivityOverview overview) =>
              setState(() {
            print("ACTIVIY_WIDGET OVERVIEW modeCallback-1: " +
                widget.overview.toString());
            widget.mode = mode;
            widget.overview = overview;
            widget.modeCallback!(widget.mode, widget.overview);
            widget.overviewCallback!(widget.overview);
            print("ACTIVIY_WIDGET OVERVIEW modeCallback-2: " +
                widget.overview.toString());

            // ActivityOverview(
            //   chosenDate: widget.overview.chosenDate,
            //   location: widget.overview.location,
            //   intensity: widget.overview.intensity,
            //   latitude: widget.overview.latitude,
            //   longitude: widget.overview.longitude));
          }),
        ),
      ],
    );
  }
}
