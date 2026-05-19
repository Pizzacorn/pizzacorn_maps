// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart' hide AddressModel;

import '../models/map/map_model.dart';

class SearchPlaceMarker extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback? onEdit;

  SearchPlaceMarker({super.key, this.address, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final String title = (address?.name ?? "").trim();
    return GestureDetector(
      onTap: onEdit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: COLOR_TEXT,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextCaption(title, color: COLOR_TEXT_BUTTONS, maxlines: 1),
            ),
          Icon(Icons.location_pin, color: COLOR_ACCENT, size: 34),
        ],
      ),
    );
  }
}
