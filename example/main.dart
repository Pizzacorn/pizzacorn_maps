import 'package:flutter/material.dart';
import 'package:pizzacorn_maps/pizzacorn_maps.dart';

void main() {
  runApp(const PizzacornMapsExample());
}

class PizzacornMapsExample extends StatelessWidget {
  const PizzacornMapsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PizzacornMap(apiKey: "", searchMode: false, markers: []),
      ),
    );
  }
}
