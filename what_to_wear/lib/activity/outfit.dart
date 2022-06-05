import 'package:what_to_wear/activity/widgets/intensity_widget.dart';

class Outfit {
  late num runningApparentTemperature;

  Outfit(num apparentTemperature, ActivityIntensity? intensity,
      num cloudsPercentage, num precipitationChance) {
    switch (intensity) {
      case ActivityIntensity.low:
        runningApparentTemperature = apparentTemperature + 1;
        break;
      case ActivityIntensity.medium:
        runningApparentTemperature = apparentTemperature + 2;
        break;
      case ActivityIntensity.high:
        runningApparentTemperature = apparentTemperature + 4;
        break;
      default:
        runningApparentTemperature = apparentTemperature;
        break;
    }
  }

  @override
  String toString() {
    return 'Outfit(runningApparentTemperature: $runningApparentTemperature)';
  }
}
