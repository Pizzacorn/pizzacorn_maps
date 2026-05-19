import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

import '../models/map/map_marker_model.dart';
import '../widgets/marker.dart';

class MiniMapStaticImage extends StatelessWidget {
  final String apiKey;
  final MapMarkerModel mapMarkerModel;
  final double width;
  final double height;
  final int zoom;
  final String markerIconUrl;

  MiniMapStaticImage({
    super.key,
    this.apiKey = "",
    MapMarkerModel? mapMarkerModel,
    this.width = double.infinity,
    this.height = 140,
    this.zoom = 16,
    this.markerIconUrl = "",
  }) : mapMarkerModel = mapMarkerModel ?? MapMarkerModel();

  @override
  Widget build(BuildContext context) {
    final double lat = mapMarkerModel.geo.geopoint.latitude;
    final double lng = mapMarkerModel.geo.geopoint.longitude;

    if (lat == 0.0 && lng == 0.0) {
      return SizedBox.shrink();
    }

    int safeZoom = zoom;
    if (safeZoom < 3) safeZoom = 3;
    if (safeZoom > 20) safeZoom = 20;

    String markersParam = "";
    if (markerIconUrl.isNotEmpty) {
      final String encodedIconUrl = Uri.encodeComponent(markerIconUrl);
      markersParam = "&markers=icon:$encodedIconUrl%7C$lat,$lng";
    }

    final String url =
        "https://maps.googleapis.com/maps/api/staticmap"
        "?center=$lat,$lng"
        "&zoom=$safeZoom"
        "&size=600x300"
        "&maptype=roadmap"
        "$markersParam"
        "&key=$apiKey";

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RADIUS),
              child: Image.network(url, fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 100,
              width: 100,
              child: MarkerCustom(mapMarkerModel: mapMarkerModel, size: 70),
            ),
          ),
        ],
      ),
    );
  }
}
