import 'package:geolocator/geolocator.dart';

Future<Position?> getCurrentLocation({bool useLastKnown = true}) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return null;
    }
  }

  Position? position;

  if (useLastKnown) {
    try {
      position = await Geolocator.getLastKnownPosition();
    } catch (error) {
      position = null;
    }
  }

  if (position == null) {
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (error) {
      return null;
    }
  }

  return position;
}
