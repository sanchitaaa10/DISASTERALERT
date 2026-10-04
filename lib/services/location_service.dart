import '../utils/constants.dart';
import '../utils/helpers.dart';

class LocationService {
  double currentLatitude = AppConstants.defaultLatitude;
  double currentLongitude = AppConstants.defaultLongitude;
  String currentLocationName = AppConstants.defaultLocationName;
  String currentDistrict = AppConstants.defaultDistrict;
  String currentState = AppConstants.defaultState;
  bool isPermissionGranted = true;

  double getDistanceTo(double targetLat, double targetLon) {
    return AppHelpers.calculateDistanceKm(
      currentLatitude,
      currentLongitude,
      targetLat,
      targetLon,
    );
  }

  void updateMockLocation({
    required double lat,
    required double lon,
    required String name,
    required String district,
  }) {
    currentLatitude = lat;
    currentLongitude = lon;
    currentLocationName = name;
    currentDistrict = district;
  }
}
