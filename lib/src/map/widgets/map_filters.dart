// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

const List<String> kMapFilters = [
  "Todo",
  "Empresas",
  "Escuelas",
  "Clubes",
  "Deportistas",
  "Entrenadores",
];

class MapFiltersButton extends StatefulWidget {
  final List<String> initialSelected;
  final ValueChanged<List<String>> onFilterChanged;
  final List<String> filters;

  MapFiltersButton({
    super.key,
    this.initialSelected = const ["Todo"],
    required this.onFilterChanged,
    this.filters = kMapFilters,
  });

  @override
  State<MapFiltersButton> createState() => MapFiltersButtonState();
}

class MapFiltersButtonState extends State<MapFiltersButton> {
  late List<String> selectedFilters;

  @override
  void initState() {
    super.initState();
    selectedFilters = widget.initialSelected.isEmpty
        ? ["Todo"]
        : widget.initialSelected;
  }

  void toggleFilter(String filter) {
    final List<String> newFilters = List<String>.from(selectedFilters);
    if (filter == "Todo") {
      newFilters
        ..clear()
        ..add("Todo");
    } else {
      newFilters.remove("Todo");
      if (newFilters.contains(filter)) {
        newFilters.remove(filter);
      } else {
        newFilters.add(filter);
      }
      if (newFilters.isEmpty) newFilters.add("Todo");
    }

    setState(() {
      selectedFilters = newFilters;
    });
    widget.onFilterChanged(selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: COLOR_BACKGROUND,
      onSelected: toggleFilter,
      itemBuilder: (context) {
        final List<PopupMenuEntry<String>> items = [];
        for (int i = 0; i < widget.filters.length; i++) {
          final String filter = widget.filters[i];
          items.add(
            PopupMenuItem<String>(
              value: filter,
              child: Row(
                children: [
                  Expanded(child: TextBody(filter)),
                  if (selectedFilters.contains(filter))
                    Icon(Icons.check, size: 18, color: COLOR_ACCENT),
                ],
              ),
            ),
          );
        }
        return items;
      },
      child: ButtonCustomIcon(
        icon: Icons.tune,
        colorBackground: COLOR_BACKGROUND,
        onPressed: () {},
      ),
    );
  }
}
