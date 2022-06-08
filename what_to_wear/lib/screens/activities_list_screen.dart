import 'package:flutter/material.dart';

class ActivitiesListScreen extends StatefulWidget {
  ActivitiesListScreen({Key? key}) : super(key: key);

  @override
  ActivitiesListScreenState createState() {
    return ActivitiesListScreenState();
  }
}

class ActivitiesListScreenState extends State<ActivitiesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Nie dodano jeszcze żadnych aktywności. Dodaj aktywność za pomocą przycisku z plusem.',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
