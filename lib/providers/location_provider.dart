import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _service = LocationService();

  double get latitude => _service.currentLatitude;
  double get longitude => _service.currentLongitude;
  String get locationName => _service.currentLocationName;
  String get district => _service.currentDistrict;
  String get state => _service.currentState;
  bool get isPermissionGranted => _service.isPermissionGranted;

  double getDistanceTo(double targetLat, double targetLon) {
    return _service.getDistanceTo(targetLat, targetLon);
  }

  void refreshLocation() {
    // In production, integrates with Geolocator package
    notifyListeners();
  }
}
