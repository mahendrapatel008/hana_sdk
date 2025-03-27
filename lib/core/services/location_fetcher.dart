import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';

Future<String> fetchCurrentLocation(String format) async {
  // Check for location permission
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Request permission if not granted
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return "Location permission denied.";
    }
  }

  // Fetch the user's current location
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    // Get the placemark from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];

      // Replace the placeholders in the format with actual placemark data
      String address = format;
      address = address.replaceAll("{name}", placemark.name ?? "Unknown");
      address = address.replaceAll("{street}", placemark.street ?? "Unknown");
      address = address.replaceAll(
          "{thoroughfare}", placemark.thoroughfare ?? "Unknown");
      address = address.replaceAll(
          "{subLocality}", placemark.subLocality ?? "Unknown");
      address = address.replaceAll(
          "{administrativeArea}", placemark.administrativeArea ?? "Unknown");
      address =
          address.replaceAll("{postalCode}", placemark.postalCode ?? "Unknown");
      address =
          address.replaceAll("{locality}", placemark.locality ?? "Unknown");
      address = address.replaceAll("{country}", placemark.country ?? "Unknown");

      // Save latitude and longitude to SharedPreferences
      SharedPrefs().latitude = position.latitude;
      SharedPrefs().longitude = position.longitude;
      SharedPrefs().locationAddress = address;
      return "Latitude: ${position.latitude}, Longitude: ${position.longitude}, Address: $address";
    } else {
      return "No placemarks found.";
    }
  } catch (e) {
    return "Error fetching location: $e";
  }
}
