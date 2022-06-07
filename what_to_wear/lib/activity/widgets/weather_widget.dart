import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/weather_info_widget.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget({Key? key, required this.forecast}) : super(key: key);
  WeatherForecast? forecast;

  @override
  WeatherWidgetState createState() {
    return WeatherWidgetState();
  }
}

class WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            'POGODA',
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(widget.forecast!.description,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeatherInfoWidget(
                    normalText: 'Temperatura: ',
                    boldText: widget.forecast!.temperature.toStringAsFixed(0) +
                        ' °C'),
                WeatherInfoWidget(
                    normalText: 'Wiatr: ',
                    boldText:
                        widget.forecast!.windSpeed.toStringAsFixed(1) + ' m/s'),
                WeatherInfoWidget(
                    normalText: 'Szansa na opady: ',
                    boldText: widget.forecast!.precipitationChance
                            .toStringAsFixed(0) +
                        ' %'),
                WeatherInfoWidget(
                    normalText: 'Zachmurzenie: ',
                    boldText:
                        widget.forecast!.cloudsPercentage.toStringAsFixed(0) +
                            ' %'),
              ],
            ),
            Image.network(
              widget.forecast!.imageUrl,
            ),
          ],
        ),
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
