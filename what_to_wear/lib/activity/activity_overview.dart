import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';
import 'package:intl/intl.dart';

class ActivityOverview {
  late DateTime chosenDate;
  late String location;
  ActivityIntensity? intensity;

  ActivityOverview(
      {required this.chosenDate,
      required this.location,
      required this.intensity});

  ActivityOverview.fromSnapshot(DocumentSnapshot snapshot) {
    chosenDate = (snapshot['date'] as Timestamp).toDate();
    location = snapshot['location'];
    String intensityString = snapshot['intensity'];
    if (intensityString == "Niska") {
      intensity = ActivityIntensity.low;
    } else if (intensityString == "Wysoka") {
      intensity = ActivityIntensity.high;
    } else {
      intensity = ActivityIntensity.medium;
    }
  }

  @override
  String toString() {
    return 'ActivityOverview(chosenDate: $chosenDate, location: $location, intensity: $intensity)';
  }

  String getDateTime() {
    return DateFormat('dd.MM.yyyy  HH:mm').format(chosenDate);
  }

  String getIntensity() {
    if (intensity == ActivityIntensity.low) {
      return "Niska";
    } else if (intensity == ActivityIntensity.medium) {
      return "Umiarkowana";
    } else if (intensity == ActivityIntensity.high) {
      return "Wysoka";
    } else {
      return "";
    }
  }
}
