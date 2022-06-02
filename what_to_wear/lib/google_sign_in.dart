import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInButton extends StatefulWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    if (user == null) {
      return ElevatedButton(
        onPressed: signIn,
        child: Row(
          children: [
            Image.asset(
              'assets/google_logo.png',
              height: 20.0,
              width: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text('Zaloguj się', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          side: const BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return PopupMenuButton<int>(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: const Icon(
            Icons.person,
            size: 30,
          ),
        ),
        onSelected: (int item) {
          if (item == 2) {
            signOut();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Zalogowano jako " + _currentUser!.email),
            value: 1,
            enabled: false,
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            child: Row(
              children: const [
                Icon(
                  Icons.logout,
                  color: Colors.purple,
                ),
                SizedBox(width: 5),
                Text('Wyloguj'),
              ],
            ),
            value: 2,
          ),
        ],
      );
    }
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print('Error signing in $e');
    }
  }

  void signOut() {
    _googleSignIn.disconnect();
  }
}
