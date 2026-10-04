import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  String _userName = 'Sanchita';
  String _userPhone = '+91 98201 54321';
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  bool _locationAccessEnabled = true;
  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  ThemeMode _themeMode = ThemeMode.light;
  DateTime? _lastSafeCheckin;

  String get userName => _userName;
  String get userPhone => _userPhone;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get locationAccessEnabled => _locationAccessEnabled;
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  DateTime? get lastSafeCheckin => _lastSafeCheckin;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString(AppConstants.keyUserName) ?? 'Sanchita';
      _userPhone = prefs.getString(AppConstants.keyUserPhone) ?? '+91 98201 54321';
      _soundEnabled = prefs.getBool(AppConstants.keyEmergencySound) ?? true;
      _vibrationEnabled = prefs.getBool(AppConstants.keyVibration) ?? true;
      _notificationsEnabled = prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
      _locationAccessEnabled = prefs.getBool(AppConstants.keyLocationAccess) ?? true;
      _isOnboardingComplete = prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;
      
      final savedTheme = prefs.getString(AppConstants.keyThemeMode);
      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedTheme == 'system') {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }

      final savedCheckin = prefs.getInt(AppConstants.keyLastSafeCheckin);
      if (savedCheckin != null) {
        _lastSafeCheckin = DateTime.fromMillisecondsSinceEpoch(savedCheckin);
      }
    } catch (_) {}
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      String modeStr = 'light';
      if (mode == ThemeMode.dark) modeStr = 'dark';
      if (mode == ThemeMode.system) modeStr = 'system';
      await prefs.setString(AppConstants.keyThemeMode, modeStr);
    } catch (_) {}
  }

  Future<void> toggleDarkMode() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> recordSafeCheckin() async {
    _lastSafeCheckin = DateTime.now();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyLastSafeCheckin, _lastSafeCheckin!.millisecondsSinceEpoch);
    } catch (_) {}
  }

  Future<void> setOnboardingComplete(bool complete) async {
    _isOnboardingComplete = complete;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyOnboardingComplete, complete);
    } catch (_) {}
  }

  Future<void> updateProfile({required String name, required String phone}) async {
    _userName = name;
    _userPhone = phone;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserName, name);
      await prefs.setString(AppConstants.keyUserPhone, phone);
    } catch (_) {}
  }

  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyEmergencySound, value);
    } catch (_) {}
  }

  Future<void> toggleVibration(bool value) async {
    _vibrationEnabled = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyVibration, value);
    } catch (_) {}
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyNotificationsEnabled, value);
    } catch (_) {}
  }

  Future<void> toggleLocationAccess(bool value) async {
    _locationAccessEnabled = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyLocationAccess, value);
    } catch (_) {}
  }
}
