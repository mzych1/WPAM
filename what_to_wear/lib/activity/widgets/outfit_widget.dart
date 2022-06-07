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
        // RichText(
        //   text: TextSpan(
        //     text: "Temp. odczuwalna podczas biegu: ",
        //     style: DefaultTextStyle.of(context).style,
        //     children: <TextSpan>[
        //       TextSpan(
        //           text: widget.outfit!.runningApparentTemperature
        //                   .toStringAsFixed(1) +
        //               ' °C',
        //           style: const TextStyle(
        //               fontWeight: FontWeight.bold, fontSize: 18)),
        //     ],
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.outfit!.basicClohesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(
                      widget.outfit!.basicClohesList[index].iconFilename,
                      height: 40.0,
                      width: 40.0,
                    ),
                    title: Text(
                      widget.outfit!.basicClohesList[index].name,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    dense: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  );
                },
              ),
            ),
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.outfit!.accesoriesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(
                      widget.outfit!.accesoriesList[index].iconFilename,
                      height: 40.0,
                      width: 40.0,
                    ),
                    title: Text(
                      widget.outfit!.accesoriesList[index].name,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    dense: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
