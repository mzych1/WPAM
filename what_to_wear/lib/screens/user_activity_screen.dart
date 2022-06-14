import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/activity_overview.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/activity_overview_widget.dart';
import 'package:what_to_wear/activity/widgets/activity_widget.dart';
import 'package:what_to_wear/activity/widgets/outfit_widget.dart';
import 'package:what_to_wear/activity/widgets/weather_widget.dart';

enum ActivityMode { add, edit, details, loggedOut }

class UserActivityScreen extends StatefulWidget {
  WeatherForecast? forecast;
  Outfit? outfit;
  ActivityOverview? overview;
  ActivityMode mode;
  String? userId;

  UserActivityScreen({Key? key, required this.mode, this.userId})
      : super(key: key);
  UserActivityScreen.fromSnapshot(
      {Key? key, required this.mode, required snapshot, this.userId})
      : super(key: key) {
    forecast = WeatherForecast.fromSnapshot(snapshot);
    outfit = Outfit.fromSnapshot(snapshot);
    overview = ActivityOverview.fromSnapshot(snapshot);
  }

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
                  modeCallback:
                      (ActivityMode mode, ActivityOverview overview) =>
                          setState(() {
                    widget.mode = mode;
                    widget.overview = overview;
                  }),
                  overviewCallback: (overview) => setState(() {
                    widget.overview = overview;
                  }),
                  userId: widget.userId,
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
                ActivityWidget.withStartData(
                  weatherCallback: (forecast) =>
                      setState(() => widget.forecast = forecast),
                  outfitCallback: (outfit) =>
                      setState(() => widget.outfit = outfit),
                  mode: ActivityMode.edit,
                  modeCallback:
                      (ActivityMode mode, ActivityOverview overview) =>
                          setState(() {
                    widget.mode = mode;
                    widget.overview = overview;
                  }),
                  overviewCallback: (overview) => setState(() {
                    widget.overview = overview;
                  }),
                  overview: widget.overview,
                  userId: widget.userId,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.mode == ActivityMode.details) {
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
                ActivityOverviewWidget(overview: widget.overview),
                WeatherWidget(forecast: widget.forecast),
                OutfitWidget(outfit: widget.outfit),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.mode = ActivityMode.edit;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10.0, top: 10.0, bottom: 10.0),
                          child: Text('Edytuj', style: TextStyle(fontSize: 24)),
                        ),
                        Icon(Icons.edit),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("Wystąpił błąd - nieznany tryb"),
              ],
            ),
          ),
        ),
      );
    }
  }
}
