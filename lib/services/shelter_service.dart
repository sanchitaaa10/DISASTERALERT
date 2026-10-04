import '../models/shelter.dart';
import '../data/mock_shelters.dart';

class ShelterService {
  final List<Shelter> _shelters = List.from(kMockShelters);

  List<Shelter> getShelters() {
    // Return sorted by distance by default
    final list = List<Shelter>.from(_shelters);
    list.sort((a, b) => a.distance.compareTo(b.distance));
    return list;
  }

  Shelter? getShelterById(String id) {
    try {
      return _shelters.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Shelter> filterShelters({
    String query = '',
    bool? onlyAvailable,
    double? maxDistanceKm,
    String? requiredFacility,
  }) {
    final list = getShelters().where((shelter) {
      if (onlyAvailable == true && (!shelter.isAvailable || shelter.availableSpots <= 0)) {
        return false;
      }
      if (maxDistanceKm != null && shelter.distance > maxDistanceKm) {
        return false;
      }
      if (requiredFacility != null && requiredFacility.isNotEmpty) {
        final hasFacility = shelter.facilities.any(
          (f) => f.toLowerCase().contains(requiredFacility.toLowerCase()),
        );
        if (!hasFacility) return false;
      }
      if (query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        final matchesName = shelter.name.toLowerCase().contains(q);
        final matchesAddress = shelter.address.toLowerCase().contains(q);
        final matchesType = shelter.shelterType.toLowerCase().contains(q);
        if (!matchesName && !matchesAddress && !matchesType) {
          return false;
        }
      }
      return true;
    }).toList();

    return list;
  }
}
