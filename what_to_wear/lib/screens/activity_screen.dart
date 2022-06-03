import 'package:flutter/material.dart';
import 'package:what_to_wear/activity/widgets/activity_widget.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  ActivityScreenState createState() {
    return ActivityScreenState();
  }
}

class ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          ActivityWidget(),
        ],
      ),
    );
  }
}
