# Pizzacorn Maps

Librería de mapas para apps Pizzacorn.

Incluye:

- `PizzacornMap`
- `MapMarkerModel`
- `GeoModel`
- `AddressModel`
- búsqueda con Places Autocomplete
- selección de ubicación con reverse geocode
- marcadores y clusters
- mapa estático

## Uso rápido

```dart
import 'package:pizzacorn_maps/pizzacorn_maps.dart';

PizzacornMap(
  apiKey: mapsApiKey,
  searchMode: true,
  markers: markerList,
  reverseGeocodeUrl: reverseGeocodeUrl,
  autocompleteUrl: autocompleteUrl,
  placeDetailsUrl: placeDetailsUrl,
  onPlaceSelected: (addressModel, geoModel) {
    // Guardar ubicación
  },
  onMarkerTap: (mapMarkerModel) {
    // Abrir detalle
  },
)
```

## Nota Pizzacorn

Mientras esta librería viva dentro de `pizzacorn_ui`, depende de:

```yaml
pizzacorn_ui:
  path: ..
```

Cuando la saques a su propio repositorio, cambia esa dependencia a Git o Pub.
