import 'dart:convert';

GooglePlaceModel googlePlaceFromPlaceIdFromJson(String str) =>
    GooglePlaceModel.fromJson(json.decode(str));

String placeFromPlaceIdToJson(GooglePlaceModel data) =>
    json.encode(data.toJson());

class GooglePlaceModel {
  GooglePlaceResultModel? result;

  GooglePlaceModel({this.result});

  factory GooglePlaceModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceModel(
        result: json["result"] == null
            ? GooglePlaceResultModel()
            : GooglePlaceResultModel.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {"result": result?.toJson()};
}

class GooglePlaceResultModel {
  List<GooglePlaceAddressComponentModel> addressComponents;
  String adrAddress;
  String formattedAddress;
  GooglePlaceGeometryModel geometry;
  String name;
  List<GooglePlacePhotoModel> photos;
  String placeId;
  String vicinity;

  GooglePlaceResultModel({
    this.addressComponents = const [],
    this.adrAddress = "",
    this.formattedAddress = "",
    GooglePlaceGeometryModel? geometry,
    this.name = "",
    this.photos = const [],
    this.placeId = "",
    this.vicinity = "",
  }) : geometry = geometry ?? GooglePlaceGeometryModel();

  factory GooglePlaceResultModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceResultModel(
        addressComponents: json["address_components"] == null
            ? []
            : List<GooglePlaceAddressComponentModel>.from(
                json["address_components"]!.map(
                  (x) => GooglePlaceAddressComponentModel.fromJson(x),
                ),
              ),
        adrAddress: json["adr_address"] ?? "",
        formattedAddress: json["formatted_address"] ?? "",
        geometry: json["geometry"] == null
            ? GooglePlaceGeometryModel()
            : GooglePlaceGeometryModel.fromJson(json["geometry"]),
        name: json["name"] ?? "",
        photos: json["photos"] == null
            ? []
            : List<GooglePlacePhotoModel>.from(
                json["photos"]!.map((x) => GooglePlacePhotoModel.fromJson(x)),
              ),
        placeId: json["place_id"] ?? "",
        vicinity: json["vicinity"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "address_components": List<dynamic>.from(
      addressComponents.map((x) => x.toJson()),
    ),
    "adr_address": adrAddress,
    "formatted_address": formattedAddress,
    "geometry": geometry.toJson(),
    "name": name,
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    "place_id": placeId,
    "vicinity": vicinity,
  };
}

class GooglePlaceAddressComponentModel {
  String longName;
  String shortName;
  List<String> types;

  GooglePlaceAddressComponentModel({
    this.longName = "",
    this.shortName = "",
    this.types = const [],
  });

  factory GooglePlaceAddressComponentModel.fromJson(
    Map<String, dynamic> json,
  ) => GooglePlaceAddressComponentModel(
    longName: json["long_name"] ?? "",
    shortName: json["short_name"] ?? "",
    types: json["types"] == null
        ? []
        : List<String>.from(json["types"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types.map((x) => x)),
  };
}

class GooglePlaceGeometryModel {
  GooglePlaceLocationModel location;

  GooglePlaceGeometryModel({GooglePlaceLocationModel? location})
    : location = location ?? GooglePlaceLocationModel();

  factory GooglePlaceGeometryModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceGeometryModel(
        location: json["location"] == null
            ? GooglePlaceLocationModel()
            : GooglePlaceLocationModel.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {"location": location.toJson()};
}

class GooglePlaceLocationModel {
  double lat;
  double lng;

  GooglePlaceLocationModel({this.lat = 0.0, this.lng = 0.0});

  factory GooglePlaceLocationModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceLocationModel(
        lat: (json["lat"] ?? 0).toDouble(),
        lng: (json["lng"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};
}

class GooglePlacePhotoModel {
  int height;
  String photoReference;
  int width;

  GooglePlacePhotoModel({
    this.height = 0,
    this.photoReference = "",
    this.width = 0,
  });

  factory GooglePlacePhotoModel.fromJson(Map<String, dynamic> json) =>
      GooglePlacePhotoModel(
        height: json["height"] ?? 0,
        photoReference: json["photo_reference"] ?? "",
        width: json["width"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "height": height,
    "photo_reference": photoReference,
    "width": width,
  };
}

class GooglePlaceReviewModel {
  String authorName;
  String authorUrl;
  String language;
  String originalLanguage;
  String profilePhotoUrl;
  int rating;
  String relativeTimeDescription;
  String text;
  int time;
  bool translated;

  GooglePlaceReviewModel({
    this.authorName = "",
    this.authorUrl = "",
    this.language = "",
    this.originalLanguage = "",
    this.profilePhotoUrl = "",
    this.rating = 0,
    this.relativeTimeDescription = "",
    this.text = "",
    this.time = 0,
    this.translated = false,
  });

  factory GooglePlaceReviewModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceReviewModel(
        authorName: json["author_name"] ?? "",
        authorUrl: json["author_url"] ?? "",
        language: json["language"] ?? "",
        originalLanguage: json["original_language"] ?? "",
        profilePhotoUrl: json["profile_photo_url"] ?? "",
        rating: json["rating"] ?? 0,
        relativeTimeDescription: json["relative_time_description"] ?? "",
        text: json["text"] ?? "",
        time: json["time"] ?? 0,
        translated: json["translated"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    "author_name": authorName,
    "author_url": authorUrl,
    "language": language,
    "original_language": originalLanguage,
    "profile_photo_url": profilePhotoUrl,
    "rating": rating,
    "relative_time_description": relativeTimeDescription,
    "text": text,
    "time": time,
    "translated": translated,
  };
}
