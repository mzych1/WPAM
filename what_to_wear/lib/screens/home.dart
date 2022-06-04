import 'package:flutter/material.dart';
import 'package:what_to_wear/screens/activity_screen.dart';

import '../auth/google_sign_in.dart';

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
      body: SingleChildScrollView(
        child: ActivityScreen(),
      ),
    );
  }
}
