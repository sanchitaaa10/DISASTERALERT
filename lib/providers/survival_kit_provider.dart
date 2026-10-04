import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_survival_kit.dart';
import '../models/survival_item.dart';
import '../utils/constants.dart';

class SurvivalKitProvider extends ChangeNotifier {
  List<SurvivalItem> _items = [];
  SurvivalCategory? _selectedCategory;
  bool _isInitialized = false;

  SurvivalKitProvider() {
    initialize();
  }

  List<SurvivalItem> get allItems => List.unmodifiable(_items);
  SurvivalCategory? get selectedCategory => _selectedCategory;
  bool get isInitialized => _isInitialized;

  List<SurvivalItem> get filteredItems {
    if (_selectedCategory == null) return _items;
    return _items.where((it) => it.category == _selectedCategory).toList();
  }

  int get totalCount => _items.length;
  int get packedCount => _items.where((it) => it.isPacked).length;
  double get readinessPercentage => totalCount > 0 ? (packedCount / totalCount) : 0.0;
  int get readinessScore => (readinessPercentage * 100).round();

  bool get isFullyReady => totalCount > 0 && packedCount == totalCount;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _items = List.from(kDefaultSurvivalItems);

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(AppConstants.keySurvivalKitItems);
      if (savedJson != null) {
        final List decoded = jsonDecode(savedJson);
        final map = {for (var item in decoded) item['id']: item['isPacked']};
        for (var item in _items) {
          if (map.containsKey(item.id)) {
            item.isPacked = map[item.id] == true;
          }
        }
      }
    } catch (_) {}

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleItemPacked(String id) async {
    final index = _items.indexWhere((it) => it.id == id);
    if (index != -1) {
      _items[index].isPacked = !_items[index].isPacked;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> addItem({
    required String title,
    required String description,
    required SurvivalCategory category,
    bool isEssential = true,
  }) async {
    final newItem = SurvivalItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      category: category,
      isEssential: isEssential,
      isPacked: false,
    );
    _items.add(newItem);
    notifyListeners();
    await _persist();
  }

  Future<void> resetAll() async {
    for (var it in _items) {
      it.isPacked = false;
    }
    notifyListeners();
    await _persist();
  }

  void setCategoryFilter(SurvivalCategory? cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_items.map((i) => i.toJson()).toList());
      await prefs.setString(AppConstants.keySurvivalKitItems, encoded);
    } catch (_) {}
  }
}
