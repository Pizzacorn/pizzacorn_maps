import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class GeoModel {
  GeoPoint geopoint;
  String geohash;

  GeoModel({GeoPoint? geopoint, this.geohash = ""})
    : geopoint = geopoint ?? const GeoPoint(0.0, 0.0);

  factory GeoModel.fromJson(Map<String, dynamic> json) => GeoModel(
    geopoint: (json['geopoint'] as GeoPoint?) ?? const GeoPoint(0.0, 0.0),
    geohash: json['geohash'] as String? ?? "",
  );

  Map<String, dynamic> toJson() => {'geopoint': geopoint, 'geohash': geohash};

  /// Set geo desde LatLng usando geoflutterfire_plus
  void setFromLatLng(LatLng latLng) {
    final point = GeoFirePoint(GeoPoint(latLng.latitude, latLng.longitude));
    geopoint = point.data['geopoint'] as GeoPoint;
    geohash = point.data['geohash'] as String;
  }

  /// Set geo desde GeoPoint
  void setFromGeoPoint(GeoPoint gp) {
    final point = GeoFirePoint(gp);
    geopoint = point.data['geopoint'] as GeoPoint;
    geohash = point.data['geohash'] as String;
  }
}

class AddressModel {
  String name; // nombre de la dirección (ej: “Oficina Central”)
  String placeID; // ID de Google Places si lo usas
  String state;
  String city;
  String country;
  String community; // comunidad autónoma (España, opcional)

  AddressModel({
    this.name = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.placeID = "",
    this.community = "",
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    name: json['name'] as String? ?? "",
    city: json['city'] as String? ?? "",
    country: json['country'] as String? ?? "",
    state: json['state'] as String? ?? "",
    community: json['community'] as String? ?? "",
    placeID: json['placeID'] as String? ?? "",
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'city': city,
    'state': state,
    'country': country,
    'community': community,
    'placeID': placeID,
  };
}
