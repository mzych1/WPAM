import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/activity_overview.dart';
import 'package:what_to_wear/activity/widgets/weather_info_widget.dart';

class ActivityOverviewWidget extends StatefulWidget {
  ActivityOverviewWidget({Key? key, required this.overview}) : super(key: key);
  ActivityOverview overview;

  @override
  ActivityOverviewWidgetState createState() {
    return ActivityOverviewWidgetState();
  }
}

class ActivityOverviewWidgetState extends State<ActivityOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            'DANE AKTYWNOŚCI',
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        WeatherInfoWidget(
            normalText: "Lokalizacja: ", boldText: widget.overview.location),
        WeatherInfoWidget(
            normalText: "Data: ", boldText: widget.overview.getDateTime()),
        WeatherInfoWidget(
            normalText: "Intensywność: ",
            boldText: widget.overview.getIntensity()),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 3,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
