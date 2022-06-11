import 'package:intl/intl.dart';

class ActivityListItem {
  String location;
  String intensity;
  late DateTime date;

  ActivityListItem(
      {required this.location, required this.intensity, required date}) {
    this.date = DateFormat("dd.MM.yyyy HH:mm").parse(date);
  }

  factory ActivityListItem.fromJson(Map<dynamic, dynamic> parsedJson) {
    print("ActivityListItem.fromJson: " + parsedJson.toString());
    return ActivityListItem(
        location: parsedJson['location'],
        intensity: parsedJson['intensity'],
        date: parsedJson['date']);
  }
}

class ActivityList {
  List<ActivityListItem> activityList;

  ActivityList({required this.activityList});

  factory ActivityList.fromJSON(Map<dynamic, dynamic> json) {
    return ActivityList(activityList: parseActivities(json));
  }

  static List<ActivityListItem> parseActivities(activitiesJSON) {
    var activitiesJsonList = activitiesJSON['activities'] as List;
    List<ActivityListItem> activitiesList = activitiesJsonList
        .map((data) => ActivityListItem.fromJson(data))
        .toList();
    return activitiesList;
  }
}
