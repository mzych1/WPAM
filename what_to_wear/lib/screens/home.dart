import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../google_sign_in.dart';
import 'activity_creation.dart';

class HomeScreen extends StatefulWidget {
  final String screenTitle = 'Dane o aktywności';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenTitle),
        actions: const [
          SignInButton(),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ActivityCreationForm(),
        ),
      ),
    );
  }
}
