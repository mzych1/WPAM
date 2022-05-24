import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleSignInAccount? _currentUser;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
        child: Column(
          children: [
            ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title: Text(
                user.displayName ?? '',
                style: const TextStyle(fontSize: 22),
              ),
              subtitle: Text(user.email, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Signed in successfully',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: signOut, child: const Text('Sign out'))
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: const [
            SizedBox(
              height: 20,
            ),
            Text(
              'You are not signed in',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(),
          ],
        ),
      );
    }
  }

  void signOut() {
    _googleSignIn.disconnect();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print('Error signing in $e');
    }
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          width: 2.0,
          color: Colors.white,
        ),
        // minimumSize: Size.zero,
        // padding: EdgeInsets.zero,
      ),
    );
  }

// na razie logowanie nie działa, przycisk coś robi, ale nie zawsze dobrze, jest niestabilny
  Future<void> signIn() async {
    // _googleSignIn.disconnect();
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print('Error signing in $e');
    }
  }
}
