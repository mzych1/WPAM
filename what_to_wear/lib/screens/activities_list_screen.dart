import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:what_to_wear/auth/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:what_to_wear/screens/review_screen.dart';
import 'package:what_to_wear/screens/user_activity_screen.dart';

typedef AccountCallback = void Function(GoogleSignInAccount? account);
DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm");

class ActivitiesListScreen extends StatefulWidget {
  ActivitiesListScreen(
      {Key? key, required this.currentUser, required this.accountCallback})
      : super(key: key);
  GoogleSignInAccount? currentUser;
  final AccountCallback accountCallback;

  @override
  ActivitiesListScreenState createState() {
    return ActivitiesListScreenState();
  }
}

class ActivitiesListScreenState extends State<ActivitiesListScreen> {
  final CollectionReference _activities =
      FirebaseFirestore.instance.collection('activities');

  // Deleteing a product by id
  Future<void> _deleteActivity(String activityId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Czy na pewno chcesz usunąć aktywność?"),
          actions: [
            TextButton(
              child: const Text("NIE"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("TAK"),
              onPressed: () async {
                await _activities.doc(activityId).delete();
                Navigator.of(context).pop();
                // Show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Usunięto aktywność'),
                      duration: Duration(seconds: 1)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twoje aktywności"),
        actions: [
          SignInButton(
            accountCallback: (account) => setState(() {
              widget.currentUser = account;
              widget.accountCallback(widget.currentUser);
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _activities
              .orderBy('date', descending: true)
              .where('user_id', isEqualTo: widget.currentUser!.id)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData &&
                streamSnapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  if ((documentSnapshot['date'] as Timestamp)
                      .toDate()
                      .isAfter(DateTime.now())) {
                    return getActivityCard(documentSnapshot,
                        Theme.of(context).scaffoldBackgroundColor);
                  } else {
                    return getActivityCard(documentSnapshot,
                        const Color.fromARGB(255, 180, 178, 202));
                  }
                },
              );
            } else if (streamSnapshot.hasData &&
                streamSnapshot.data!.docs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Nie dodano jeszcze żadnych aktywności. Dodaj aktywność za pomocą przycisku z plusem.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              print(streamSnapshot.toString());
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserActivityScreen(
                mode: ActivityMode.add,
                userId: widget.currentUser!.id,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getActivityCard(DocumentSnapshot documentSnapshot, Color cardColor) {
    return Card(
      margin: const EdgeInsets.all(5),
      color: cardColor,
      elevation: 5,
      child: ListTile(
        title: Text(dateFormat
            .format((documentSnapshot['date'] as Timestamp).toDate())),
        subtitle: Text(documentSnapshot['location']),
        onTap: () {
          if ((documentSnapshot['date'] as Timestamp)
              .toDate()
              .isAfter(DateTime.now())) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserActivityScreen.fromSnapshot(
                  mode: ActivityMode.details,
                  snapshot: documentSnapshot,
                  userId: widget.currentUser!.id,
                ),
              ),
            );
          } else if (documentSnapshot['reviewed']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserActivityScreen.fromSnapshot(
                  mode: ActivityMode.reviewed,
                  snapshot: documentSnapshot,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserActivityScreen.fromSnapshot(
                  mode: ActivityMode.past,
                  snapshot: documentSnapshot,
                  userId: widget.currentUser!.id,
                ),
              ),
            );
          }
        },
        trailing: SizedBox(
          width: 50,
          child: Row(
            children: [
              // This icon button is used to delete a single product
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteActivity(documentSnapshot.id)),
            ],
          ),
        ),
      ),
    );
  }
}
