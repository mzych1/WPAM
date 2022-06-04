import 'package:flutter/material.dart';

class WeatherInfoWidget extends StatefulWidget {
  WeatherInfoWidget(
      {Key? key, required this.normalText, required this.boldText})
      : super(key: key);
  String normalText;
  String boldText;

  @override
  WeatherInfoWidgetState createState() {
    return WeatherInfoWidgetState();
  }
}

class WeatherInfoWidgetState extends State<WeatherInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.normalText,
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: widget.boldText,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}
