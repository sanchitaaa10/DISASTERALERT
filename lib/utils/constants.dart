import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'DisasterAlert';
  static const String appTagline = 'Stay Alert. Stay Safe.';
  static const String appNumber = '24';
  static const String problemStatement = '74';
  static const String version = '1.0.0 (B.Tech Demo)';

  // Default Geo Coordinates (Kharghar, Navi Mumbai)
  static const double defaultLatitude = 19.0473;
  static const double defaultLongitude = 73.0699;
  static const String defaultLocationName = 'Kharghar, Navi Mumbai';
  static const String defaultDistrict = 'Raigad / Navi Mumbai';
  static const String defaultState = 'Maharashtra, India';

  // National Disaster Helpline
  static const String nationalDisasterHelpline = '112';
  static const String ambulanceHelpline = '108';
  static const String policeHelpline = '100';
  static const String fireHelpline = '101';
  static const String ndrfHelpline = '01124363260';
  static const String womenHelpline = '1091';
  static const String childHelpline = '1098';

  // Storage Keys for SharedPreferences
  static const String keyOnboardingComplete = 'pref_onboarding_complete';
  static const String keyUserName = 'pref_user_name';
  static const String keyUserPhone = 'pref_user_phone';
  static const String keyEmergencySound = 'pref_emergency_sound';
  static const String keyVibration = 'pref_vibration';
  static const String keyLocationAccess = 'pref_location_access';
  static const String keyNotificationsEnabled = 'pref_notifications_enabled';
  static const String keyTrustedContacts = 'pref_trusted_contacts_json';
  static const String keyThemeMode = 'pref_theme_mode';
  static const String keyLastSafeCheckin = 'pref_last_safe_checkin';
  static const String keySurvivalKitItems = 'pref_survival_kit_items';

  // Educational Safety Tips for Emergency Dashboard
  static const List<Map<String, String>> safetyTips = [
    {
      'title': 'During an Earthquake',
      'instruction': 'Drop, Cover, and Hold On. Stay away from windows, outer walls, and falling objects.',
      'category': 'Earthquake Safety',
      'icon': 'vibration',
    },
    {
      'title': 'Flash Flood Alert',
      'instruction': 'Never attempt to drive or walk through moving floodwater. Six inches of water can knock you down.',
      'category': 'Flood Safety',
      'icon': 'water_damage',
    },
    {
      'title': 'Cyclone Preparedness',
      'instruction': 'Secure loose outdoor objects, stay indoors away from glass panes, and keep emergency radio ready.',
      'category': 'Cyclone Protocol',
      'icon': 'cyclone',
    },
    {
      'title': 'Residential Fire Safety',
      'instruction': 'Crawl low under smoke where air is cleaner. Feel doors before opening them with back of your hand.',
      'category': 'Fire Safety',
      'icon': 'local_fire_department',
    },
    {
      'title': 'Extreme Heat Wave',
      'instruction': 'Stay hydrated with electrolytes, avoid direct afternoon sun (12 PM - 3 PM), wear light cotton clothes.',
      'category': 'Heat Protocol',
      'icon': 'wb_sunny',
    },
  ];
}

class AppColors {
  // Primary Emergency Colors (Material 3 Compliant)
  static const Color emergencyRed = Color(0xFFD32F2F);
  static const Color emergencyRedDark = Color(0xFFB71C1C);
  static const Color emergencyRedLight = Color(0xFFFFCDD2);
  static const Color emergencyRedSurface = Color(0xFFFFF5F5);

  static const Color warningOrange = Color(0xFFF57C00);
  static const Color warningOrangeLight = Color(0xFFFFE0B2);
  static const Color warningOrangeSurface = Color(0xFFFFF8E1);

  static const Color cautionYellow = Color(0xFFFBC02D);
  static const Color cautionYellowLight = Color(0xFFFFF9C4);

  static const Color safeGreen = Color(0xFF2E7D32);
  static const Color safeGreenLight = Color(0xFFC8E6C9);
  static const Color safeGreenSurface = Color(0xFFF1F8E9);

  static const Color infoBlue = Color(0xFF1565C0);
  static const Color infoBlueLight = Color(0xFFBBDEFB);
  static const Color infoBlueSurface = Color(0xFFE3F2FD);

  // Surface & Neutral Colors (Clean Light Aesthetic)
  static const Color background = Color(0xFFF8FAFC); // Slate-tinted crisp light
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Tactical Radar & HUD Colors
  static const Color radarGrid = Color(0xFFE2E8F0);
  static const Color radarSweep = Color(0x33D32F2F);
  static const Color radarPointSafe = Color(0xFF2E7D32);
  static const Color radarPointHazard = Color(0xFFD32F2F);
}

class AppColorsDark {
  // Tactical Dark & Night HUD Palette
  static const Color background = Color(0xFF090D16); // Deep Tactical OLED Slate
  static const Color surface = Color(0xFF111827); // Slate 900
  static const Color surfaceVariant = Color(0xFF1E293B); // Slate 800
  static const Color border = Color(0xFF334155); // Slate 700
  static const Color borderLight = Color(0xFF1E293B);

  // High-Visibility Neon Accents
  static const Color emergencyRed = Color(0xFFFF4D4F);
  static const Color emergencyRedDark = Color(0xFFD32F2F);
  static const Color emergencyRedLight = Color(0x33FF4D4F);
  static const Color emergencyRedSurface = Color(0x1FFF4D4F);

  static const Color warningOrange = Color(0xFFFB923C);
  static const Color warningOrangeLight = Color(0x33FB923C);
  static const Color warningOrangeSurface = Color(0x1FFB923C);

  static const Color cautionYellow = Color(0xFFFACC15);
  static const Color cautionYellowLight = Color(0x33FACC15);

  static const Color safeGreen = Color(0xFF22C55E);
  static const Color safeGreenLight = Color(0x3322C55E);
  static const Color safeGreenSurface = Color(0x1F22C55E);

  static const Color infoBlue = Color(0xFF38BDF8);
  static const Color infoBlueLight = Color(0x3338BDF8);
  static const Color infoBlueSurface = Color(0x1F38BDF8);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Tactical Radar & HUD Colors
  static const Color radarGrid = Color(0xFF334155);
  static const Color radarSweep = Color(0x44FF4D4F);
  static const Color radarPointSafe = Color(0xFF22C55E);
  static const Color radarPointHazard = Color(0xFFFF4D4F);
}

class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double pill = 999.0;
}
