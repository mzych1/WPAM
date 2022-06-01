import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../place_service.dart';
import 'cities_search.dart';

enum ActivityIntensity { low, medium, high }

class ActivityCreationForm extends StatefulWidget {
  const ActivityCreationForm({Key? key}) : super(key: key);

  @override
  ActivityCreationFormState createState() {
    return ActivityCreationFormState();
  }
}

class ActivityCreationFormState extends State<ActivityCreationForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  final DateFormat timeFormatter = DateFormat('HH:mm');
  ActivityIntensity? _intensity = ActivityIntensity.medium;
  final _controller = TextEditingController();
  String _latitude = '';
  String _longitude = '';

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Planowana pora rozpoczęcia:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async {
                        final date = await pickDate();
                        if (date == null) return; // CANCEL

                        final newDateTime = DateTime(date.year, date.month,
                            date.day, dateTime.hour, dateTime.minute);

                        setState(() => dateTime = newDateTime);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, right: 5.0),
                              child: Text(
                                dateFormatter.format(dateTime),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_month,
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async {
                        final time = await pickTime();
                        if (time == null) return; // CANCEL

                        final newDateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            time.hour,
                            time.minute);

                        setState(() => dateTime = newDateTime);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, right: 10.0),
                              child: Text(
                                '$hours:$minutes',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const Icon(Icons.access_time)
                          ]),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
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
                  groupValue: _intensity,
                  onChanged: (ActivityIntensity? value) {
                    setState(() {
                      _intensity = value;
                    });
                  },
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                title: const Text('Umiarkowana'),
                leading: Radio<ActivityIntensity>(
                  value: ActivityIntensity.medium,
                  groupValue: _intensity,
                  onChanged: (ActivityIntensity? value) {
                    setState(() {
                      _intensity = value;
                    });
                  },
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                title: const Text('Wysoka'),
                leading: Radio<ActivityIntensity>(
                  value: ActivityIntensity.high,
                  groupValue: _intensity,
                  onChanged: (ActivityIntensity? value) {
                    setState(() {
                      _intensity = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
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
                      _latitude = placeGeometry.latitude;
                      _longitude = placeGeometry.longitude;
                    });
                  }
                },
                decoration: InputDecoration(
                  icon: Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 10,
                    height: 10,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.purple, //tego użyć tylko ze zmienna boolean
                    ),
                  ),
                  hintText: "Wybierz miejscowość",
                  contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              onPressed: chooseOutfit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(right: 8.0, top: 10.0, bottom: 10.0),
                    child:
                        Text('Dobierz strój', style: TextStyle(fontSize: 24)),
                  ),
                  Image.asset(
                    'assets/running_man.png',
                    height: 40.0,
                    width: 40.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now(), // wyznaczać jako bieżący dzień
      lastDate: DateTime.now()
          .add(const Duration(days: 5))); // wyznaczać jako 5 dni później

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  void chooseOutfit() {
    if (_latitude.isEmpty || _longitude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nie wybrano lokalizacji'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
    }
  }
}
