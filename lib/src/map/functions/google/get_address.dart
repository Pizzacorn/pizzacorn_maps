import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../models/map/map_model.dart';

Future<AddressModel> getAddress({
  required LatLng latLng,
  required String reverseGeocodeUrl,
}) async {
  try {
    final Uri uri = Uri.parse(reverseGeocodeUrl).replace(
      queryParameters: {"latlng": "${latLng.latitude},${latLng.longitude}"},
    );

    final http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return AddressModel(name: "NO VALIDA");
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String status = data["status"] as String? ?? "UNKNOWN_ERROR";
    if (status != "OK") {
      return AddressModel(name: "NO VALIDA");
    }

    final List<dynamic> results = data["results"] as List<dynamic>? ?? [];
    if (results.isEmpty) {
      return AddressModel(name: "NO VALIDA");
    }

    final Map<String, dynamic> first = results.first as Map<String, dynamic>;
    final List<dynamic> rawComponents =
        first["address_components"] as List<dynamic>? ?? [];
    final List<Map<String, dynamic>> components = [];
    for (int i = 0; i < rawComponents.length; i++) {
      if (rawComponents[i] is Map<String, dynamic>) {
        components.add(rawComponents[i] as Map<String, dynamic>);
      }
    }

    final String streetNumber = findGoogleAddressComponent(components, [
      "street_number",
    ]);
    final String route = findGoogleAddressComponent(components, ["route"]);
    final String locality = findGoogleAddressComponent(components, [
      "locality",
    ]);
    final String postalTown = findGoogleAddressComponent(components, [
      "postal_town",
    ]);
    final String sublocality = findGoogleAddressComponent(components, [
      "sublocality",
      "sublocality_level_1",
    ]);
    final String community = findGoogleAddressComponent(components, [
      "administrative_area_level_1",
    ]);
    final String state = findGoogleAddressComponent(components, [
      "administrative_area_level_2",
    ]);
    final String country = findGoogleAddressComponent(components, ["country"]);
    final String formattedAddress = first["formatted_address"] as String? ?? "";

    String name = formattedAddress;
    if (route.isNotEmpty && streetNumber.isNotEmpty) {
      name = "$route $streetNumber";
    } else if (route.isNotEmpty) {
      name = route;
    }

    return AddressModel(
      name: name,
      city: locality.isNotEmpty
          ? locality
          : (postalTown.isNotEmpty ? postalTown : sublocality),
      state: state.isNotEmpty ? state : community,
      country: country,
      community: community,
      placeID: first["place_id"] as String? ?? "",
    );
  } catch (error) {
    debugPrint("getAddress error: $error");
    return AddressModel(name: "NO VALIDA");
  }
}

String findGoogleAddressComponent(
  List<Map<String, dynamic>> components,
  List<String> types,
) {
  for (int i = 0; i < components.length; i++) {
    final List<dynamic> rawTypes =
        components[i]["types"] as List<dynamic>? ?? [];
    for (int j = 0; j < rawTypes.length; j++) {
      for (int k = 0; k < types.length; k++) {
        if (rawTypes[j].toString() == types[k]) {
          return components[i]["long_name"] as String? ?? "";
        }
      }
    }
  }
  return "";
}
