// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class CentralPin extends StatelessWidget {
  final bool isMoving;

  CentralPin({super.key, this.isMoving = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedPadding(
        duration: Duration(milliseconds: 180),
        padding: EdgeInsets.only(bottom: isMoving ? 35 : 0),
        child: Icon(Icons.location_pin, color: COLOR_ACCENT, size: 46),
      ),
    );
  }
}
