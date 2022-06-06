import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/outfit.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Temp. odczuwalna podczas biegu: ",
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: widget.outfit!.runningApparentTemperature.toString() +
                      ' °C',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.outfit!.clohesList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.outfit!.clohesList[index].name),
              dense: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            );
          },
        ),
      ],
    );
  }
}
