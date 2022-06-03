import 'package:flutter/material.dart';

enum ActivityIntensity { low, medium, high }

typedef IntensityCallback = void Function(ActivityIntensity? intensity);

class IntensityWidget extends StatefulWidget {
  IntensityWidget({Key? key, required this.callback, required this.intensity})
      : super(key: key);
  final IntensityCallback callback;
  ActivityIntensity? intensity;

  @override
  IntensityWidgetState createState() {
    return IntensityWidgetState();
  }
}

class IntensityWidgetState extends State<IntensityWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Intensywność:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          title: const Text('Niska'),
          leading: Radio<ActivityIntensity>(
            value: ActivityIntensity.low,
            groupValue: widget.intensity,
            onChanged: (ActivityIntensity? value) {
              setState(() {
                widget.intensity = value;
              });
              widget.callback(widget.intensity);
            },
          ),
        ),
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          title: const Text('Umiarkowana'),
          leading: Radio<ActivityIntensity>(
            value: ActivityIntensity.medium,
            groupValue: widget.intensity,
            onChanged: (ActivityIntensity? value) {
              setState(() {
                widget.intensity = value;
              });
              widget.callback(widget.intensity);
            },
          ),
        ),
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          title: const Text('Wysoka'),
          leading: Radio<ActivityIntensity>(
            value: ActivityIntensity.high,
            groupValue: widget.intensity,
            onChanged: (ActivityIntensity? value) {
              setState(() {
                widget.intensity = value;
              });
              widget.callback(widget.intensity);
            },
          ),
        ),
      ],
    );
  }
}
