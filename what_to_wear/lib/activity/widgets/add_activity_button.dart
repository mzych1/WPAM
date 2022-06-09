import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddActivityButton extends StatelessWidget {
  AddActivityButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final databaseReference = FirebaseDatabase.instance.ref();
        // pierwsze pobranie danych
        await databaseReference.once().then((event) {
          print('Data : ${event.snapshot.value}');
        });
        print("koniec pobierania danych - 1");

        // dodanie danych
        databaseReference.child('4').set({'key4': 'val4'});

        // drugie pobranie danych
        await databaseReference.once().then((event) {
          print('Data : ${event.snapshot.value}');
        });
        print("koniec pobierania danych - 2");

        // databaseReference
        //     .set({'name': 'Deepak Nishad', 'description': 'Team Lead'});
        // print("Wciśnięto przycisk FloatingActionButton - 2");
        // final snapshot = await databaseReference.get();
        // if (snapshot.exists) {
        //   print(snapshot.value);
        // } else {
        //   print('No data available.');
        //   print("Wciśnięto przycisk FloatingActionButton - 3");
        // }

        // await databaseReference.once().then((event) {
        //   final dataSnapshot = event.snapshot;
        //   if (dataSnapshot.value != null) {
        //     print("powinny wyświetlić się dane");
        //     print('Data : ${dataSnapshot.value}');
        //   } else {
        //     print("chyba brak danych");
        //   }
        // });
        // print("koniec pobierania danych");
      },
      child: const Icon(Icons.add),
    );
  }
}
