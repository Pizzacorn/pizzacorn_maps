import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../models/google/google_place_model.dart';

Future<GooglePlaceResultModel> getPlace({
  required String placeId,
  required String placeDetailsUrl,
  String language = "es",
}) async {
  try {
    final Uri uri = Uri.parse(
      placeDetailsUrl,
    ).replace(queryParameters: {"place_id": placeId, "language": language});

    final http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint("Place details HTTP ${response.statusCode}: ${response.body}");
      return GooglePlaceResultModel();
    }

    final GooglePlaceModel model = googlePlaceFromPlaceIdFromJson(
      response.body,
    );
    return model.result ?? GooglePlaceResultModel();
  } catch (error) {
    debugPrint("getPlace error: $error");
    return GooglePlaceResultModel();
  }
}
