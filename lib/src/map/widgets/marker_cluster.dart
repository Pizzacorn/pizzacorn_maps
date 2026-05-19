// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class MarkerClusterCustom extends StatelessWidget {
  final List<Marker> markers;

  MarkerClusterCustom({super.key, this.markers = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: COLOR_ACCENT, shape: BoxShape.circle),
      child: Center(
        child: TextSubtitle(
          formatCount(markers.length),
          color: COLOR_TEXT_BUTTONS,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

String formatCount(int count) {
  if (count >= 1000000) {
    final double value = count / 1000000.0;
    return "${value.toStringAsFixed(value >= 10 ? 0 : 1)}M";
  }
  if (count >= 1000) {
    final double value = count / 1000.0;
    return "${value.toStringAsFixed(value >= 10 ? 0 : 1)}k";
  }
  return count.toString();
}
