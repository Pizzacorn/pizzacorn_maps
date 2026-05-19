import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../models/google/google_autocomplete_model.dart';

Future<List<GoogleAutocompletePredictionModel>> autocompleteGooglePlace({
  required String text,
  required LatLng latLng,
  required int radius,
  required String autocompleteUrl,
  String language = "es",
}) async {
  try {
    final Uri uri = Uri.parse(autocompleteUrl).replace(
      queryParameters: {
        "input": text,
        "location": "${latLng.latitude},${latLng.longitude}",
        "radius": "$radius",
        "language": language,
      },
    );

    final http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint("Autocomplete HTTP ${response.statusCode}: ${response.body}");
      return [];
    }

    final GoogleAutocompleteModel googlePlace = autocompletePlaceFromJson(
      response.body,
    );
    final List<GoogleAutocompletePredictionModel> predictions = [];
    final int total = googlePlace.predictions.length > 4
        ? 4
        : googlePlace.predictions.length;
    for (int i = 0; i < total; i++) {
      predictions.add(googlePlace.predictions[i]);
    }
    return predictions;
  } catch (error) {
    debugPrint("Autocomplete error: $error");
    return [];
  }
}
