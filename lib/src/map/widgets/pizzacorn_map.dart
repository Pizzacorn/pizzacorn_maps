import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster_plus/flutter_map_marker_cluster_plus.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

import '../models/map/map_marker_model.dart';
import '../models/map/map_model.dart';

class PizzacornMapPrediction {
  String placeId;
  String title;
  String subtitle;
  String description;

  PizzacornMapPrediction({
    this.placeId = "",
    this.title = "",
    this.subtitle = "",
    this.description = "",
  });
}

class PizzacornMap extends StatefulWidget {
  final String apiKey;
  final bool searchMode;
  final List<MapMarkerModel> markers;
  final String reverseGeocodeUrl;
  final String autocompleteUrl;
  final String placeDetailsUrl;
  final GeoModel? initialGeo;
  final double initialZoom;
  final double markerSize;
  final bool showZoomControls;
  final bool showSearchBar;
  final Function(AddressModel, GeoModel)? onPlaceSelected;
  final Function(MapMarkerModel)? onMarkerTap;

  // ignore: prefer_const_constructors_in_immutables
  PizzacornMap({
    super.key,
    this.apiKey = "",
    this.searchMode = false,
    this.markers = const [],
    this.reverseGeocodeUrl = "",
    this.autocompleteUrl = "",
    this.placeDetailsUrl = "",
    this.initialGeo,
    this.initialZoom = 12,
    this.markerSize = 90,
    this.showZoomControls = true,
    this.showSearchBar = true,
    this.onPlaceSelected,
    this.onMarkerTap,
  });

  @override
  PizzacornMapState createState() => PizzacornMapState();
}

class PizzacornMapState extends State<PizzacornMap> {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  Timer? searchTimer;
  Timer? moveTimer;
  bool loading = false;
  bool searchLoading = false;
  bool isMoving = false;
  LatLng centerPosition = const LatLng(40.416775, -3.703790);
  AddressModel selectedAddress = AddressModel();
  GeoModel selectedGeo = GeoModel();
  List<PizzacornMapPrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    centerPosition = readInitialCenter();
    selectedGeo.setFromLatLng(centerPosition);
    if (widget.searchMode) {
      Future.microtask(() {
        updateCenterAddress();
      });
    }
  }

  @override
  void didUpdateWidget(covariant PizzacornMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGeo != widget.initialGeo &&
        widget.initialGeo != null) {
      centerPosition = readInitialCenter();
      selectedGeo.setFromLatLng(centerPosition);
      mapController.move(centerPosition, widget.initialZoom);
    }
  }

  @override
  void dispose() {
    searchTimer?.cancel();
    moveTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  LatLng readInitialCenter() {
    if (widget.initialGeo != null) {
      return LatLng(
        widget.initialGeo!.geopoint.latitude,
        widget.initialGeo!.geopoint.longitude,
      );
    }

    if (widget.markers.isNotEmpty) {
      final GeoModel markerGeo = widget.markers.first.geo;
      if (markerGeo.geopoint.latitude != 0 ||
          markerGeo.geopoint.longitude != 0) {
        return LatLng(
          markerGeo.geopoint.latitude,
          markerGeo.geopoint.longitude,
        );
      }
    }

    return const LatLng(40.416775, -3.703790);
  }

  String buildTileUrl() {
    return "https://maps.googleapis.com/maps/vt?x={x}&y={y}&z={z}&key=${widget.apiKey}";
  }

  void onMapPositionChanged(MapCamera position, bool hasGesture) {
    if (!widget.searchMode || !hasGesture) return;
    centerPosition = position.center;
    selectedGeo.setFromLatLng(centerPosition);
    setState(() {
      isMoving = true;
    });

    moveTimer?.cancel();
    moveTimer = Timer(Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        isMoving = false;
      });
      updateCenterAddress();
    });
  }

  Future<void> updateCenterAddress() async {
    if (widget.reverseGeocodeUrl.trim().isEmpty) return;

    final AddressModel addressModel = await getAddressFromUrl(centerPosition);
    if (!mounted) return;

    setState(() {
      selectedAddress = addressModel;
      if (addressModel.name.trim().isNotEmpty &&
          searchController.text.trim().isEmpty) {
        searchController.text = addressModel.name;
      }
    });
  }

  Future<AddressModel> getAddressFromUrl(LatLng latLng) async {
    try {
      final Uri uri = Uri.parse(widget.reverseGeocodeUrl).replace(
        queryParameters: {"latlng": "${latLng.latitude},${latLng.longitude}"},
      );
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) return AddressModel(name: "NO VALIDA");

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final String status = data["status"] as String? ?? "UNKNOWN_ERROR";
      if (status != "OK") return AddressModel(name: "NO VALIDA");

      final List<dynamic> results = data["results"] as List<dynamic>? ?? [];
      if (results.isEmpty) return AddressModel(name: "NO VALIDA");

      final Map<String, dynamic> first = results.first as Map<String, dynamic>;
      final List<dynamic> rawComponents =
          first["address_components"] as List<dynamic>? ?? [];
      final List<Map<String, dynamic>> components = [];
      for (int i = 0; i < rawComponents.length; i++) {
        if (rawComponents[i] is Map<String, dynamic>) {
          components.add(rawComponents[i] as Map<String, dynamic>);
        }
      }

      final String streetNumber = findAddressComponent(components, [
        "street_number",
      ]);
      final String route = findAddressComponent(components, ["route"]);
      final String locality = findAddressComponent(components, ["locality"]);
      final String postalTown = findAddressComponent(components, [
        "postal_town",
      ]);
      final String sublocality = findAddressComponent(components, [
        "sublocality",
        "sublocality_level_1",
      ]);
      final String community = findAddressComponent(components, [
        "administrative_area_level_1",
      ]);
      final String stateProvince = findAddressComponent(components, [
        "administrative_area_level_2",
      ]);
      final String country = findAddressComponent(components, ["country"]);
      final String formattedAddress =
          first["formatted_address"] as String? ?? "";

      String name = formattedAddress;
      if (route.isNotEmpty && streetNumber.isNotEmpty) {
        name = "$route $streetNumber";
      } else if (route.isNotEmpty) {
        name = route;
      }

      return AddressModel(
        name: name,
        city: locality.isNotEmpty
            ? locality
            : (postalTown.isNotEmpty ? postalTown : sublocality),
        state: stateProvince.isNotEmpty ? stateProvince : community,
        community: community,
        country: country,
        placeID: first["place_id"] as String? ?? "",
      );
    } catch (error) {
      debugPrint("PizzacornMap geocode error: $error");
      return AddressModel(name: "NO VALIDA");
    }
  }

  String findAddressComponent(
    List<Map<String, dynamic>> components,
    List<String> types,
  ) {
    for (int i = 0; i < components.length; i++) {
      final List<dynamic> rawTypes =
          components[i]["types"] as List<dynamic>? ?? [];
      for (int j = 0; j < rawTypes.length; j++) {
        for (int k = 0; k < types.length; k++) {
          if (rawTypes[j].toString() == types[k]) {
            return components[i]["long_name"] as String? ?? "";
          }
        }
      }
    }
    return "";
  }

  void onSearchChanged(String text) {
    searchTimer?.cancel();
    searchTimer = Timer(Duration(milliseconds: 300), () {
      searchPlaces(text);
    });
  }

  Future<void> searchPlaces(String text) async {
    final String query = text.trim();
    if (query.length < 2 || widget.autocompleteUrl.trim().isEmpty) {
      setState(() {
        searchLoading = false;
        predictions = [];
      });
      return;
    }

    setState(() {
      searchLoading = true;
    });

    try {
      final Uri uri = Uri.parse(widget.autocompleteUrl).replace(
        queryParameters: {
          "input": query,
          "location": "${centerPosition.latitude},${centerPosition.longitude}",
          "radius": "15000",
          "language": "es",
        },
      );
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        setState(() {
          searchLoading = false;
        });
        return;
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawPredictions =
          data["predictions"] as List<dynamic>? ?? [];
      final List<PizzacornMapPrediction> newPredictions = [];
      final int total = rawPredictions.length > 4 ? 4 : rawPredictions.length;

      for (int i = 0; i < total; i++) {
        final Map<String, dynamic> item =
            rawPredictions[i] as Map<String, dynamic>;
        final Map<String, dynamic> formatting =
            item["structured_formatting"] as Map<String, dynamic>? ?? {};
        newPredictions.add(
          PizzacornMapPrediction(
            placeId: item["place_id"] as String? ?? "",
            title:
                formatting["main_text"] as String? ??
                item["description"] as String? ??
                "",
            subtitle: formatting["secondary_text"] as String? ?? "",
            description: item["description"] as String? ?? "",
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        predictions = newPredictions;
        searchLoading = false;
      });
    } catch (error) {
      debugPrint("PizzacornMap autocomplete error: $error");
      if (!mounted) return;
      setState(() {
        searchLoading = false;
      });
    }
  }

  Future<void> selectPrediction(PizzacornMapPrediction prediction) async {
    if (widget.placeDetailsUrl.trim().isEmpty ||
        prediction.placeId.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
      predictions = [];
      searchController.text = prediction.title;
    });

    try {
      final Uri uri = Uri.parse(widget.placeDetailsUrl).replace(
        queryParameters: {"place_id": prediction.placeId, "language": "es"},
      );
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final Map<String, dynamic> result =
            data["result"] as Map<String, dynamic>? ?? {};
        final Map<String, dynamic> geometry =
            result["geometry"] as Map<String, dynamic>? ?? {};
        final Map<String, dynamic> location =
            geometry["location"] as Map<String, dynamic>? ?? {};
        final double latitude =
            (location["lat"] as num? ?? centerPosition.latitude).toDouble();
        final double longitude =
            (location["lng"] as num? ?? centerPosition.longitude).toDouble();
        centerPosition = LatLng(latitude, longitude);
        selectedGeo.setFromLatLng(centerPosition);
        mapController.move(centerPosition, widget.initialZoom);
        selectedAddress = await getAddressFromUrl(centerPosition);
      }
    } catch (error) {
      debugPrint("PizzacornMap place error: $error");
    }

    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  void saveSelectedPlace() {
    if (widget.onPlaceSelected == null) return;
    widget.onPlaceSelected!(selectedAddress, selectedGeo);
  }

  List<Marker> buildMarkers() {
    final List<Marker> mapMarkers = [];
    for (int i = 0; i < widget.markers.length; i++) {
      final MapMarkerModel markerModel = widget.markers[i];
      final double latitude = markerModel.geo.geopoint.latitude;
      final double longitude = markerModel.geo.geopoint.longitude;
      if (latitude == 0 && longitude == 0) continue;
      mapMarkers.add(
        Marker(
          point: LatLng(latitude, longitude),
          width: widget.markerSize,
          height: widget.markerSize,
          child: buildMarker(markerModel),
        ),
      );
    }
    return mapMarkers;
  }

  Widget buildMarker(MapMarkerModel markerModel) {
    return GestureDetector(
      onTap: () {
        if (widget.onMarkerTap != null) {
          widget.onMarkerTap!(markerModel);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ProfileImageCustom(
            imageUrl: markerModel.image,
            size: widget.markerSize * 0.68,
            outerBorderColor: COLOR_ACCENT,
          ),
          if (markerModel.name.trim().isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: COLOR_ACCENT,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextCaption(
                  markerModel.name,
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

  Widget buildCluster(List<Marker> markers) {
    return Container(
      decoration: BoxDecoration(
        color: COLOR_ACCENT,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: COLOR_SHADOW.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: TextSubtitle(
          markers.length.toString(),
          color: COLOR_TEXT_BUTTONS,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    if (!widget.showSearchBar ||
        (!widget.searchMode && widget.autocompleteUrl.trim().isEmpty)) {
      return SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: PADDING_ALL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldCustom(
              controller: searchController,
              hintText: "Buscar ubicación",
              prefixIcon: Icons.search,
              suffixIcon: Icons.close,
              onSuffixPressed: () {
                searchController.clear();
                setState(() {
                  predictions = [];
                });
              },
              onChanged: onSearchChanged,
              colorFill: COLOR_BACKGROUND,
              shadow: true,
            ),
            if (searchLoading)
              Container(
                margin: EdgeInsets.only(top: SPACE_SMALL),
                padding: PADDING_ALL,
                decoration: BoxDecoration(
                  color: COLOR_BACKGROUND,
                  borderRadius: BorderRadius.circular(RADIUS),
                ),
                child: LoadingCustomWidget(size: 22),
              ),
            if (predictions.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: SPACE_SMALL),
                constraints: BoxConstraints(maxHeight: 260),
                decoration: BoxDecoration(
                  color: COLOR_BACKGROUND,
                  borderRadius: BorderRadius.circular(RADIUS),
                  boxShadow: [
                    BoxShadow(
                      color: COLOR_SHADOW.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: PADDING_ALL_SMALL,
                  itemCount: predictions.length,
                  separatorBuilder: (context, index) => Space(SPACE_SMALL),
                  itemBuilder: (context, index) {
                    final PizzacornMapPrediction prediction =
                        predictions[index];
                    return TextButton(
                      style: styleTransparent(),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        selectPrediction(prediction);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.place_outlined, color: COLOR_ACCENT),
                          Space(SPACE_SMALL),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBody(
                                  prediction.title.isEmpty
                                      ? prediction.description
                                      : prediction.title,
                                ),
                                if (prediction.subtitle.isNotEmpty)
                                  TextCaption(prediction.subtitle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCentralPin() {
    if (!widget.searchMode) return SizedBox.shrink();

    return IgnorePointer(
      child: Center(
        child: AnimatedPadding(
          duration: Duration(milliseconds: 180),
          padding: EdgeInsets.only(bottom: isMoving ? 35 : 0),
          child: Icon(Icons.location_pin, color: COLOR_ACCENT, size: 46),
        ),
      ),
    );
  }

  Widget buildZoomControls() {
    if (!widget.showZoomControls) {
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
                  final double zoom = mapController.camera.zoom + 1;
                  mapController.move(mapController.camera.center, zoom);
                },
              ),
              Space(SPACE_SMALL),
              ButtonCustomIcon(
                icon: Icons.remove,
                colorBackground: COLOR_BACKGROUND,
                onPressed: () {
                  final double zoom = mapController.camera.zoom - 1;
                  mapController.move(mapController.camera.center, zoom);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    if (!widget.searchMode || widget.onPlaceSelected == null) {
      return SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Container(
          padding: PADDING_ALL,
          color: COLOR_BACKGROUND,
          child: ButtonCustom(
            text: "Guardar ubicación",
            onPressed: saveSelectedPlace,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> mapMarkers = buildMarkers();

    return Loading(
      loading: loading,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: centerPosition,
              initialZoom: widget.initialZoom,
              onPositionChanged: onMapPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: buildTileUrl(),
                tileProvider: NetworkTileProvider(),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: Size(42, 42),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(50),
                  maxZoom: 15,
                  markers: mapMarkers,
                  builder: (context, markers) => buildCluster(markers),
                ),
              ),
            ],
          ),
          buildCentralPin(),
          buildSearchBar(),
          buildZoomControls(),
          buildBottomBar(),
        ],
      ),
    );
  }
}
