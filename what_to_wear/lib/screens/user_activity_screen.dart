import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/activity_widget.dart';

enum ActivityMode { add, edit, details, loggedOut }

class UserActivityScreen extends StatefulWidget {
  WeatherForecast? forecast;
  Outfit? outfit;
  ActivityMode mode;

  UserActivityScreen({Key? key, required this.mode}) : super(key: key);

  @override
  State<UserActivityScreen> createState() => UserActivityScreenState();
}

class UserActivityScreenState extends State<UserActivityScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.mode == ActivityMode.add) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dodawanie aktywności'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ActivityWidget(
                  weatherCallback: (forecast) =>
                      setState(() => widget.forecast = forecast),
                  outfitCallback: (outfit) =>
                      setState(() => widget.outfit = outfit),
                  mode: ActivityMode.add,
                  modeCallback: (ActivityMode mode) => setState(() {
                    widget.mode = mode;
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.mode == ActivityMode.edit) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edycja aktywności'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("tryb edit"),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Szczegóły'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("tryb details"),
              ],
            ),
          ),
        ),
      );
    }
  }
}
