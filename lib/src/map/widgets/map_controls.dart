// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class MapControls extends StatelessWidget {
  final MapController mapController;
  final bool removeZoomButtons;

  MapControls({
    super.key,
    required this.mapController,
    this.removeZoomButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    if (removeZoomButtons) {
      return SizedBox.shrink();
    }

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: PADDING_ALL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonCustomIcon(
                icon: Icons.add,
                colorBackground: COLOR_BACKGROUND,
                onPressed: () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom + 1,
                  );
                },
              ),
              Space(SPACE_SMALL),
              ButtonCustomIcon(
                icon: Icons.remove,
                colorBackground: COLOR_BACKGROUND,
                onPressed: () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom - 1,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
