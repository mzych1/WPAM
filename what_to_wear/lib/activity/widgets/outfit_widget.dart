import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/weather_info_widget.dart';

class OutfitWidget extends StatefulWidget {
  OutfitWidget({Key? key, required this.outfit}) : super(key: key);
  Outfit? outfit;

  @override
  OutfitWidgetState createState() {
    return OutfitWidgetState();
  }
}

class OutfitWidgetState extends State<OutfitWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.outfit!.runningApparentTemperature.toString());
  }
}
