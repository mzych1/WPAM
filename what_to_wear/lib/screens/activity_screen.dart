import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/activity_widget.dart';
import 'package:what_to_wear/activity/widgets/outfit_widget.dart';
import 'package:what_to_wear/activity/widgets/weather_widget.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen({Key? key}) : super(key: key);
  WeatherForecast? forecast;
  Outfit? outfit;

  @override
  ActivityScreenState createState() {
    return ActivityScreenState();
  }
}

class ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ActivityWidget(
            weatherCallback: (forecast) =>
                setState(() => widget.forecast = forecast),
            outfitCallback: (outfit) => setState(() => widget.outfit = outfit),
          ),
        ],
      ),
    );
  }
}
