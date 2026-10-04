import 'package:flutter/material.dart';
import '../models/shelter.dart';
import '../services/shelter_service.dart';

class ShelterProvider extends ChangeNotifier {
  final ShelterService _service = ShelterService();

  String _searchQuery = '';
  bool _onlyAvailable = false;
  double? _maxDistanceKm;
  String? _selectedFacility;
  String? _selectedShelterId;

  String get searchQuery => _searchQuery;
  bool get onlyAvailable => _onlyAvailable;
  double? get maxDistanceKm => _maxDistanceKm;
  String? get selectedFacility => _selectedFacility;
  String? get selectedShelterId => _selectedShelterId;

  List<Shelter> get allShelters => _service.getShelters();

  List<Shelter> get filteredShelters {
    return _service.filterShelters(
      query: _searchQuery,
      onlyAvailable: _onlyAvailable,
      maxDistanceKm: _maxDistanceKm,
      requiredFacility: _selectedFacility,
    );
  }

  Shelter? get selectedShelter {
    if (_selectedShelterId == null) return null;
    return _service.getShelterById(_selectedShelterId!);
  }

  int get availableSheltersCount =>
      allShelters.where((s) => s.isAvailable && s.availableSpots > 0).length;

  int get totalAvailableCapacity => allShelters
      .where((s) => s.isAvailable)
      .fold(0, (sum, s) => sum + s.availableSpots);

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleOnlyAvailable(bool value) {
    _onlyAvailable = value;
    notifyListeners();
  }

  void setMaxDistance(double? distance) {
    _maxDistanceKm = distance;
    notifyListeners();
  }

  void setSelectedFacility(String? facility) {
    _selectedFacility = facility;
    notifyListeners();
  }

  void selectShelter(String? shelterId) {
    _selectedShelterId = shelterId;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _onlyAvailable = false;
    _maxDistanceKm = null;
    _selectedFacility = null;
    notifyListeners();
  }

  Shelter? getShelterById(String id) {
    return _service.getShelterById(id);
  }
}
