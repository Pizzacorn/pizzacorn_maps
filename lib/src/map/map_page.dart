// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import 'models/map/map_marker_model.dart';
import 'models/map/map_model.dart';
import 'widgets/pizzacorn_map.dart';

class MapPage extends StatelessWidget {
  final String apiKey;
  final bool searchMode;
  final List<MapMarkerModel> markers;
  final String reverseGeocodeUrl;
  final String autocompleteUrl;
  final String placeDetailsUrl;
  final GeoModel? initialGeo;
  final double initialZoom;
  final Function(AddressModel, GeoModel)? onPlaceSelected;
  final Function(MapMarkerModel)? onMarkerTap;

  MapPage({
    super.key,
    this.apiKey = "",
    this.searchMode = false,
    this.markers = const [],
    this.reverseGeocodeUrl = "",
    this.autocompleteUrl = "",
    this.placeDetailsUrl = "",
    this.initialGeo,
    this.initialZoom = 12,
    this.onPlaceSelected,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PizzacornMap(
        apiKey: apiKey,
        searchMode: searchMode,
        markers: markers,
        reverseGeocodeUrl: reverseGeocodeUrl,
        autocompleteUrl: autocompleteUrl,
        placeDetailsUrl: placeDetailsUrl,
        initialGeo: initialGeo,
        initialZoom: initialZoom,
        onPlaceSelected: onPlaceSelected,
        onMarkerTap: onMarkerTap,
      ),
    );
  }
}
