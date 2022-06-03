import 'dart:convert';

import 'package:http/http.dart';
import 'package:what_to_wear/auth/secrets.dart';

class PlaceGeometry {
  String latitude;
  String longitude;

  PlaceGeometry({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'PlaceGeometry(latitude: $latitude, longitude: $longitude)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();
  final sessionToken;

  PlaceApiProvider(this.sessionToken);

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    final request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&language=pl&components=country:pl&key=$googleApiKey&sessiontoken=$sessionToken');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<PlaceGeometry> getPlaceGeometryFromId(String placeId) async {
    final request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleApiKey&sessiontoken=$sessionToken');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final geometry = result['result']['geometry']["location"];
        // build result
        final placeGeometry = PlaceGeometry(
            latitude: geometry['lat'].toString(),
            longitude: geometry['lng'].toString());
        return placeGeometry;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
