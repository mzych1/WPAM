import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/activity_widget.dart';
import 'package:what_to_wear/activity/widgets/weather_widget.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen({Key? key}) : super(key: key);
  WeatherForecast? forecast;

  @override
  ActivityScreenState createState() {
    return ActivityScreenState();
  }
}

class ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.forecast == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActivityWidget(
              callback: (forecast) =>
                  setState(() => widget.forecast = forecast),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WeatherWidget(forecast: widget.forecast),
            ActivityWidget(
              callback: (forecast) =>
                  setState(() => widget.forecast = forecast),
            ),
          ],
        ),
      );
    }
  }
}
