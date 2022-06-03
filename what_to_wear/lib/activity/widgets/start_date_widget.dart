import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateTimeCallback = void Function(DateTime dateTime);

class StartDateWidget extends StatefulWidget {
  StartDateWidget(
      {Key? key, required this.callback, required this.chosenDateTime})
      : super(key: key);
  final DateTimeCallback callback;
  DateTime chosenDateTime;

  @override
  StartDateWidgetState createState() {
    return StartDateWidgetState();
  }
}

class StartDateWidgetState extends State<StartDateWidget> {
  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  final DateFormat timeFormatter = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Column(
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

                  final newDateTime = DateTime(date.year, date.month, date.day,
                      widget.chosenDateTime.hour, widget.chosenDateTime.minute);

                  setState(() => widget.chosenDateTime = newDateTime);
                  widget.callback(widget.chosenDateTime);
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 5.0),
                    child: Text(
                      dateFormatter.format(widget.chosenDateTime),
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
                      widget.chosenDateTime.year,
                      widget.chosenDateTime.month,
                      widget.chosenDateTime.day,
                      time.hour,
                      time.minute);

                  setState(() => widget.chosenDateTime = newDateTime);
                  widget.callback(widget.chosenDateTime);
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 10.0),
                    child: Text(
                      timeFormatter.format(widget.chosenDateTime),
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
    );
  }

  static DateTime setStartDateTime() {
    DateTime dateTime = DateTime.now();
    if (dateTime.minute < 30) {
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, dateTime.hour, 30);
    } else {
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, dateTime.hour + 1, 0);
    }
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: widget.chosenDateTime,
      firstDate: DateTime.now(), // bieżący dzień
      lastDate: DateTime.now().add(const Duration(days: 5))); // 5 dni później

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: widget.chosenDateTime.hour,
          minute: widget.chosenDateTime.minute));
}
