// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart' hide PizzacornMapPrediction;

import 'pizzacorn_map.dart';

class MapSearchBar extends StatefulWidget {
  final LatLng center;
  final ValueChanged<PizzacornMapPrediction>? onPredictionTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextEditingController? controller;

  MapSearchBar({
    super.key,
    this.center = const LatLng(40.416775, -3.703790),
    this.onPredictionTap,
    this.onChanged,
    this.readOnly = false,
    this.controller,
  });

  @override
  State<MapSearchBar> createState() => MapSearchBarState();
}

class MapSearchBarState extends State<MapSearchBar> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldCustom(
      controller: controller,
      hintText: "Buscar ubicación",
      prefixIcon: Icons.search,
      suffixIcon: Icons.close,
      readOnly: widget.readOnly,
      colorFill: COLOR_BACKGROUND,
      onChanged: widget.onChanged,
      onSuffixPressed: () {
        controller.clear();
        if (widget.onChanged != null) widget.onChanged!("");
      },
    );
  }
}
