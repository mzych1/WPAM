import 'package:flutter/material.dart';

import '../place_service.dart';

class CitiesSearch extends SearchDelegate<Suggestion> {
  CitiesSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  late PlaceApiProvider apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Wyczyść',
        icon: const Icon(
          Icons.clear,
          color: Colors.purple,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  String get searchFieldLabel => 'Wyszukaj';

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Cofnij',
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.purple,
      ),
      onPressed: () {
        close(context,
            Suggestion('', '')); // jako drugi parametr powinien być null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Należy wybrać miejscowość z listy',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == "" ? null : apiClient.fetchSuggestions(query),
      builder: (context, AsyncSnapshot snapshot) => query == ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Wpisz nazwę miejscowości',
                style: TextStyle(fontSize: 16),
              ),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title:
                        Text((snapshot.data[index] as Suggestion).description),
                    onTap: () {
                      close(context, snapshot.data[index] as Suggestion);
                    },
                  ),
                  itemCount: snapshot.data?.length,
                )
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Ładowanie wyników...',
                    style: TextStyle(fontSize: 16),
                  )),
    );
  }
}
