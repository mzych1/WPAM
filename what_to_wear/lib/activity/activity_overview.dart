import 'package:what_to_wear/activity/widgets/intensity_widget.dart';
import 'package:intl/intl.dart';

class ActivityOverview {
  DateTime chosenDate;
  String location;
  ActivityIntensity? intensity;

  ActivityOverview(
      {required this.chosenDate,
      required this.location,
      required this.intensity});

  @override
  String toString() {
    return 'ActivityOverview(chosenDate: $chosenDate, location: $location, intensity: $intensity)';
  }

  String getDateTime() {
    return DateFormat('dd.MM.yyyy  kk:mm').format(chosenDate);
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
