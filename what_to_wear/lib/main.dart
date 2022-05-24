import 'package:flutter/material.dart';
import 'package:what_to_wear/google_sign_in.dart';
import 'package:what_to_wear/screens/activity_creation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final String title = 'What to wear';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const ActivityCreationScreen(),
      // home: Home(title: title),
    );
  }
}
