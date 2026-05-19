import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart' show parseDate;

import 'map_model.dart';

class MapMarkerModel {
  String id;
  String image;
  String name;
  GeoModel geo;
  DateTime createdAt;
  DateTime modifyAt;

  MapMarkerModel({
    this.id = "",
    this.image = "",
    this.name = "",
    GeoModel? geo,
    DateTime? createdAt,
    DateTime? modifyAt,
  }) : geo = geo ?? GeoModel(),
       createdAt = createdAt ?? DateTime(2000),
       modifyAt = modifyAt ?? DateTime(2000);

  factory MapMarkerModel.fromJson(Map<String, dynamic> json) {
    return MapMarkerModel(
      id: json["id"] as String? ?? "",
      image: json["image"] as String? ?? "",
      name: json["name"] as String? ?? "",
      geo: GeoModel.fromJson(readGeoJson(json)),
      createdAt: parseDate(json["createdAt"]),
      modifyAt: parseDate(json["modifyAt"]),
    );
  }

  static Map<String, dynamic> readGeoJson(Map<String, dynamic> json) {
    final dynamic rawGeo = json["geo"] ?? json["location"];

    if (rawGeo is GeoModel) return rawGeo.toJson();
    if (rawGeo is Map<String, dynamic>) return rawGeo;
    if (rawGeo is GeoPoint) {
      final GeoModel geoModel = GeoModel();
      geoModel.setFromGeoPoint(rawGeo);
      return geoModel.toJson();
    }

    final num latitude = json["latitude"] as num? ?? json["lat"] as num? ?? 0;
    final num longitude = json["longitude"] as num? ?? json["lng"] as num? ?? 0;
    final GeoModel geoModel = GeoModel();
    geoModel.setFromLatLng(LatLng(latitude.toDouble(), longitude.toDouble()));
    return geoModel.toJson();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "name": name,
      "geo": geo.toJson(),
      "createdAt": createdAt,
      "modifyAt": modifyAt,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> json = toJson();
    json["createdAt"] = FieldValue.serverTimestamp();
    json["modifyAt"] = FieldValue.serverTimestamp();
    return json;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> json = toJson();
    json.remove("id");
    json.remove("createdAt");
    json["modifyAt"] = FieldValue.serverTimestamp();
    return json;
  }

  MapMarkerModel copyWith({
    String? id,
    String? image,
    String? name,
    GeoModel? geo,
    DateTime? createdAt,
    DateTime? modifyAt,
  }) {
    return MapMarkerModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      geo: geo ?? this.geo,
      createdAt: createdAt ?? this.createdAt,
      modifyAt: modifyAt ?? this.modifyAt,
    );
  }
}
