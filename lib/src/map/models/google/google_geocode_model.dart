import 'dart:convert';

GoogleGeocodeModel geocodeLatLngFromJson(String str) =>
    GoogleGeocodeModel.fromJson(json.decode(str));

String geocodeLatLngToJson(GoogleGeocodeModel data) =>
    json.encode(data.toJson());

class GoogleGeocodeModel {
  List<GoogleGeocodeResultModel>? results;

  GoogleGeocodeModel({this.results});

  factory GoogleGeocodeModel.fromJson(Map<String, dynamic> json) =>
      GoogleGeocodeModel(
        results: json["results"] == null
            ? []
            : List<GoogleGeocodeResultModel>.from(
                json["results"]!.map(
                  (x) => GoogleGeocodeResultModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class GoogleGeocodeResultModel {
  List<GoogleGeocodeAddressComponentModel>? addressComponents;
  String? formattedAddress;
  GoogleGeocodeGeometryModel? geometry;
  String? placeId;

  GoogleGeocodeResultModel({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
  });

  factory GoogleGeocodeResultModel.fromJson(Map<String, dynamic> json) =>
      GoogleGeocodeResultModel(
        addressComponents: json["address_components"] == null
            ? []
            : List<GoogleGeocodeAddressComponentModel>.from(
                json["address_components"]!.map(
                  (x) => GoogleGeocodeAddressComponentModel.fromJson(x),
                ),
              ),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : GoogleGeocodeGeometryModel.fromJson(json["geometry"]),
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
    "address_components": addressComponents == null
        ? []
        : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
    "formatted_address": formattedAddress,
    "geometry": geometry?.toJson(),
    "place_id": placeId,
  };
}

class GoogleGeocodeAddressComponentModel {
  String? longName;
  String? shortName;
  List<String>? types;

  GoogleGeocodeAddressComponentModel({
    this.longName,
    this.shortName,
    this.types,
  });

  factory GoogleGeocodeAddressComponentModel.fromJson(
    Map<String, dynamic> json,
  ) => GoogleGeocodeAddressComponentModel(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: json["types"] == null
        ? []
        : List<String>.from(json["types"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
  };
}

class GoogleGeocodeGeometryModel {
  GoogleGeocodeLocationModel? location;

  GoogleGeocodeGeometryModel({this.location});

  factory GoogleGeocodeGeometryModel.fromJson(Map<String, dynamic> json) =>
      GoogleGeocodeGeometryModel(
        location: json["location"] == null
            ? null
            : GoogleGeocodeLocationModel.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {"location": location?.toJson()};
}

class GoogleGeocodeLocationModel {
  double? lat;
  double? lng;

  GoogleGeocodeLocationModel({this.lat, this.lng});

  factory GoogleGeocodeLocationModel.fromJson(Map<String, dynamic> json) =>
      GoogleGeocodeLocationModel(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};
}
