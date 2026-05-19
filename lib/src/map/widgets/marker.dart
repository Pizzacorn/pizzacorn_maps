import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

import '../models/map/map_marker_model.dart';

class MarkerCustom extends StatelessWidget {
  final MapMarkerModel mapMarkerModel;
  final VoidCallback? onTap;
  final double size;

  MarkerCustom({
    super.key,
    MapMarkerModel? mapMarkerModel,
    this.onTap,
    this.size = 80,
  }) : mapMarkerModel = mapMarkerModel ?? MapMarkerModel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ProfileImageCustom(
            imageUrl: mapMarkerModel.image,
            size: size,
            outerBorderColor: COLOR_ACCENT,
          ),
          if (mapMarkerModel.name.trim().isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: COLOR_ACCENT,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextCaption(
                  mapMarkerModel.name,
                  color: COLOR_TEXT_BUTTONS,
                  maxlines: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
