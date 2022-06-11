import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:what_to_wear/auth/google_sign_in.dart';
import 'package:what_to_wear/model/activity.dart';

final databaseReference = FirebaseDatabase.instance.ref('activities');
typedef AccountCallback = void Function(GoogleSignInAccount? account);

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
  Future<void> _deleteProduct(String activityId) async {
    await _activities.doc(activityId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Usunięto aktywność')));
  }

  Future<void> _addActivity() async {
    await _activities
        .add({"location": 'Lublin, Polska', "date": '15.06.2022 10:50'});
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
          stream: _activities.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['location']),
                      subtitle: Text(documentSnapshot['date'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            // This icon button is used to delete a single product
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteProduct(documentSnapshot.id)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addActivity(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: const [
  //         Text(
  //           'Nie dodano jeszcze żadnych aktywności. Dodaj aktywność za pomocą przycisku z plusem.',
  //           style: TextStyle(fontSize: 18),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class MakeCall {
  List<ActivityListItem> listItems = [];

  Future<List<ActivityListItem>> firebaseCalls(
      DatabaseReference databaseReference) async {
    ActivityList activityList;
    await databaseReference.once().then((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      activityList = ActivityList.fromJSON(data);
      listItems.addAll(activityList.activityList);
      print('data : $data');
    });

    return listItems;
  }
}
