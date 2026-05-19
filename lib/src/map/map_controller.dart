import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/map/map_marker_model.dart';

class MapPageState {
  final bool isLoading;
  final String isError;
  final List<MapMarkerModel> markers;

  MapPageState({
    this.isLoading = false,
    this.isError = "",
    this.markers = const [],
  });

  MapPageState copyWith({
    bool? isLoading,
    String? isError,
    List<MapMarkerModel>? markers,
  }) {
    return MapPageState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      markers: markers ?? this.markers,
    );
  }
}

final StateNotifierProvider<MapPageController, MapPageState> mapProvider =
    StateNotifierProvider<MapPageController, MapPageState>((ref) {
      return MapPageController();
    });

class MapPageController extends StateNotifier<MapPageState> {
  MapPageController() : super(MapPageState());

  void setMarkers(List<MapMarkerModel> markers) {
    state = state.copyWith(markers: markers);
  }
}
