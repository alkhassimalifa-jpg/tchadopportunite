import 'package:geolocator/geolocator.dart';
 
class LocationService {
  LocationService._();
 
  /// Vérifie et demande les permissions de localisation
  static Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
 
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
 
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
 
    return true;
  }
 
  /// Récupère la position actuelle
  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return null;
 
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }
 
  /// Calcule la distance entre deux points en km
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final meters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return meters / 1000;
  }
 
  /// Coordonnées par défaut : N'Djamena, Tchad
  static const double defaultLatitude = 12.1348;
  static const double defaultLongitude = 15.0557;
}