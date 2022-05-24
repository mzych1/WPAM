import 'package:flutter/material.dart';

import '../google_sign_in.dart';

class ActivityCreationScreen extends StatelessWidget {
  static const screenTitle = 'Dane o aktywności';

  const ActivityCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(screenTitle),
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

class ActivityCreationForm extends StatefulWidget {
  const ActivityCreationForm({Key? key}) : super(key: key);

  @override
  ActivityCreationFormState createState() {
    return ActivityCreationFormState();
  }
}

class ActivityCreationFormState extends State<ActivityCreationForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Planowana data rozpoczęcia:',
              labelStyle: TextStyle(
                fontSize: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pole wymagane';
              }
              return null;
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Czas trwania:',
              labelStyle: TextStyle(
                fontSize: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pole wymagane';
              }
              return null;
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Intensywność:',
              labelStyle: TextStyle(
                fontSize: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pole wymagane';
              }
              return null;
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Lokalizacja:',
              labelStyle: TextStyle(
                fontSize: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pole wymagane';
              }
              return null;
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wciśnięto przycisk')),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Dobierz strój',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
