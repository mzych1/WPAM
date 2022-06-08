import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:what_to_wear/screens/activities_list_screen.dart';
import 'package:what_to_wear/screens/activity_screen.dart';

import '../auth/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String screenTitle = 'Dane o aktywności';
  GoogleSignInAccount? _currentUser;

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget._currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.screenTitle),
          actions: [
            SignInButton(
              accountCallback: (account) => setState(() {
                widget._currentUser = account;
              }),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ActivityScreen(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.screenTitle),
          actions: [
            SignInButton(
              accountCallback: (account) => setState(() {
                widget._currentUser = account;
              }),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ActivitiesListScreen(),
        ),
      );
    }
  }
}
