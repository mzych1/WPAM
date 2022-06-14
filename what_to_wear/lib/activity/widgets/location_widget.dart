import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:what_to_wear/activity/cities_search.dart';
import 'package:what_to_wear/activity/place_service.dart';

typedef LocationCallback = void Function(
    String latitude, String longitude, String location);

class LocationWidget extends StatefulWidget {
  LocationWidget(
      {Key? key,
      required this.callback,
      required this.latitude,
      required this.longitude,
      required this.location})
      : super(key: key);
  final LocationCallback callback;
  String latitude;
  String longitude;
  String location;

  @override
  LocationWidgetState createState() {
    return LocationWidgetState();
  }
}

class LocationWidgetState extends State<LocationWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.location;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokalizacja:',
          style: TextStyle(fontSize: 20),
        ),
        TextField(
          controller: _controller,
          readOnly: true,
          onTap: () async {
            // generate a new token here
            final sessionToken = const Uuid().v4();
            final Suggestion? result = await showSearch(
              context: context,
              delegate: CitiesSearch(sessionToken),
            );
            // This will change the text displayed in the TextField
            if (result != null && result.placeId.isNotEmpty) {
              final placeGeometry = await PlaceApiProvider(sessionToken)
                  .getPlaceGeometryFromId(result.placeId);
              setState(() {
                _controller.text = result.description;
                widget.latitude = placeGeometry.latitude;
                widget.longitude = placeGeometry.longitude;
                widget.location = result.description;
              });
            }
            widget.callback(widget.latitude, widget.longitude, widget.location);
          },
          decoration: InputDecoration(
            icon: Container(
              margin: const EdgeInsets.only(left: 10),
              width: 10,
              height: 10,
              child: const Icon(
                Icons.location_pin,
              ),
            ),
            hintText: "Wybierz miejscowość",
            contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
          ),
        ),
      ],
    );
  }
}
