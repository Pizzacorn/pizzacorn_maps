// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class CustomMarkerMyPosition extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onPressed;

  CustomMarkerMyPosition({super.key, this.imageUrl = "", this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ProfileImageCustom(
            imageUrl: imageUrl,
            size: 70,
            outerBorderColor: COLOR_INFO,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: COLOR_INFO,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextCaption(
                "Tú",
                color: COLOR_TEXT_BUTTONS,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
