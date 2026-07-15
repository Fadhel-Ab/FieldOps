import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Required import to resolve the error

class LocationResult {
  final Position position;
  final String address;

  LocationResult({required this.position, required this.address});
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    final Geocoding geocoding = Geocoding();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location Permission denied");
    }

    Position? position = await Geolocator.getLastKnownPosition();
    position ??= await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    String readableAddress = "Address not found";
    try {
      // This global function now resolves correctly via the package import above
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        readableAddress =
            "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}"
                .replaceAll(
                  RegExp(r'^,\s*|,\s*$'),
                  '',
                ); // Clean up trailing commas if values are null
      }
    } catch (e) {
      readableAddress = "Coordinates obtained, address unavailable";
    }

    return LocationResult(position: position, address: readableAddress);
  }
}
