import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:disaster_alert/models/alert.dart';
import 'package:disaster_alert/models/survival_item.dart';
import 'package:disaster_alert/providers/alert_provider.dart';
import 'package:disaster_alert/providers/contact_provider.dart';
import 'package:disaster_alert/providers/location_provider.dart';
import 'package:disaster_alert/providers/notification_provider.dart';
import 'package:disaster_alert/providers/survival_kit_provider.dart';
import 'package:disaster_alert/providers/theme_provider.dart';
import 'package:disaster_alert/screens/alerts/report_hazard_screen.dart';
import 'package:disaster_alert/screens/survival/survival_kit_screen.dart';
import 'package:disaster_alert/screens/tools/rescue_beacon_screen.dart';
import 'package:flutter/services.dart';
import 'package:disaster_alert/services/siren_audio_service.dart';
import 'package:disaster_alert/widgets/environmental_telemetry_card.dart';
import 'package:disaster_alert/widgets/safety_checkin_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (call) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async => 1,
    );
  });

  group('ThemeProvider & Dark Mode Tests', () {
    test('Initial theme defaults to light and allows toggle to dark', () async {
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      expect(themeProvider.themeMode, ThemeMode.light);
      expect(themeProvider.isDarkMode, isFalse);

      await themeProvider.toggleDarkMode();
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(themeProvider.isDarkMode, isTrue);

      await themeProvider.toggleDarkMode();
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('recordSafeCheckin records timestamp accurately', () async {
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      expect(themeProvider.lastSafeCheckin, isNull);
      await themeProvider.recordSafeCheckin();
      expect(themeProvider.lastSafeCheckin, isNotNull);
    });
  });

  group('SurvivalKitProvider Tests', () {
    test('Loads default survival items and computes readiness', () async {
      final kitProvider = SurvivalKitProvider();
      await kitProvider.initialize();

      expect(kitProvider.totalCount, greaterThan(10));
      expect(kitProvider.packedCount, 0);
      expect(kitProvider.readinessScore, 0);

      final firstItem = kitProvider.allItems.first;
      await kitProvider.toggleItemPacked(firstItem.id);

      expect(kitProvider.packedCount, 1);
      expect(kitProvider.readinessPercentage, greaterThan(0.0));

      await kitProvider.resetAll();
      expect(kitProvider.packedCount, 0);
    });

    test('Can add custom item and filter by category', () async {
      final kitProvider = SurvivalKitProvider();
      await kitProvider.initialize();
      final initialCount = kitProvider.totalCount;

      await kitProvider.addItem(
        title: 'Emergency Inhaler',
        description: 'Rescue beta-agonist inhaler',
        category: SurvivalCategory.medical,
      );

      expect(kitProvider.totalCount, initialCount + 1);

      kitProvider.setCategoryFilter(SurvivalCategory.medical);
      for (final item in kitProvider.filteredItems) {
        expect(item.category, SurvivalCategory.medical);
      }
    });
  });

  group('Citizen Hazard Reporting Tests', () {
    test('AlertProvider can add custom citizen hazard report', () {
      final alertProvider = AlertProvider();
      final notifProvider = NotificationProvider();
      final initialCount = alertProvider.allAlerts.length;

      final hazard = AlertModel(
        id: 'hazard_test_1',
        title: 'Citizen Alert: Waterlogging at Sector 14',
        type: DisasterType.flood,
        description: 'Road inundated with 2 feet of monsoon runoff.',
        severity: AlertSeverity.high,
        location: 'Kharghar Sector 14 Underpass',
        timestamp: DateTime.now(),
        safetyInstructions: ['Avoid underpass', 'Use arterial flyover'],
      );

      alertProvider.addAlert(hazard, notifProvider);

      expect(alertProvider.allAlerts.length, initialCount + 1);
      expect(alertProvider.allAlerts.first.title, contains('Citizen Alert'));
      expect(notifProvider.notifications.any((n) => n.title.contains('Community Hazard Reported')), isTrue);
    });
  });

  group('SirenAudioService Tests', () {
    test('startSiren and stopSiren manage audio state accurately', () async {
      final service = SirenAudioService();
      expect(service.isPlaying, isFalse);

      await service.startSiren();
      expect(service.isPlaying, isTrue);

      await service.stopSiren();
      expect(service.isPlaying, isFalse);
    });
  });

  group('Widget Tests for Improvisation Features', () {
    testWidgets('EnvironmentalTelemetryCard renders micro-climate stats', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EnvironmentalTelemetryCard(),
          ),
        ),
      );

      expect(find.text('Kharghar Micro-Climate Grid'), findsOneWidget);
      expect(find.text('RAIN RATE'), findsOneWidget);
      expect(find.text('FLOOD STAGE'), findsOneWidget);
    });

    testWidgets('SafetyCheckinCard renders and displays safe button', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => ContactProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SafetyCheckinCard(),
            ),
          ),
        ),
      );

      expect(find.text('SAFETY CHECK-IN'), findsOneWidget);
      expect(find.text('I Am Safe'), findsOneWidget);
    });

    testWidgets('SurvivalKitScreen renders checklist and readiness gauge', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SurvivalKitProvider()),
          ],
          child: const MaterialApp(
            home: SurvivalKitScreen(),
          ),
        ),
      );

      expect(find.text('Evacuation "Go-Bag"'), findsOneWidget);
      expect(find.text('Evacuation Readiness'), findsOneWidget);
      expect(find.text('Add Custom Item'), findsOneWidget);
    });

    testWidgets('RescueBeaconScreen renders strobe and siren sections', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LocationProvider()),
          ],
          child: const MaterialApp(
            home: RescueBeaconScreen(),
          ),
        ),
      );

      expect(find.text('Tactical Rescue Tools'), findsOneWidget);
      expect(find.text('Optical Rescue Screen Strobe'), findsOneWidget);
      expect(find.text('Audible Distress Siren'), findsOneWidget);
      expect(find.text('Tactical Compass & Telemetry'), findsOneWidget);
    });

    testWidgets('ReportHazardScreen renders form fields', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => AlertProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const MaterialApp(
            home: ReportHazardScreen(),
          ),
        ),
      );

      expect(find.text('Report Hazard / Incident'), findsOneWidget);
      expect(find.text('HAZARD CATEGORY'), findsOneWidget);
      expect(find.text('BROADCAST HAZARD REPORT'), findsOneWidget);
    });
  });
}
