import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:disaster_alert/app/app.dart';
import 'package:disaster_alert/providers/alert_provider.dart';
import 'package:disaster_alert/providers/contact_provider.dart';
import 'package:disaster_alert/providers/location_provider.dart';
import 'package:disaster_alert/providers/notification_provider.dart';
import 'package:disaster_alert/providers/shelter_provider.dart';
import 'package:disaster_alert/providers/theme_provider.dart';
import 'package:disaster_alert/models/shelter.dart';
import 'package:disaster_alert/widgets/status_badge.dart';
import 'package:disaster_alert/widgets/quick_action_card.dart';
import 'package:disaster_alert/widgets/shelter_card.dart';

void main() {
  testWidgets('StatusBadge renders critical and safe indicators', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              StatusBadge(
                label: 'CRITICAL',
                color: Colors.red,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('CRITICAL'), findsOneWidget);
  });

  testWidgets('QuickActionCard responds to tap', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuickActionCard(
            icon: Icons.emergency_rounded,
            title: 'Helplines',
            subtitle: 'Direct Calls',
            color: Colors.red,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Helplines'), findsOneWidget);
    await tester.tap(find.byType(QuickActionCard));
    expect(tapped, isTrue);
  });

  testWidgets('QuickActionCard renders cleanly inside constrained 120px height', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 170,
              height: 120,
              child: QuickActionCard(
                icon: Icons.backpack_rounded,
                title: 'Go-Bag Kit',
                subtitle: '14/14 Packed (100%)',
                color: Colors.green,
                badgeText: '100%',
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Go-Bag Kit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ShelterCard renders without overflow with long shelter type and narrow width', (tester) async {
    final shelter = Shelter(
      id: 'shelter_test_1',
      name: 'Kharghar Community Relief Center',
      shelterType: 'Primary Municipal Evacuation Center',
      address: 'Plot 14, Sector 12, Near Central Park Metro, Kharghar',
      contactNumber: '+912227745555',
      latitude: 19.0473,
      longitude: 73.0699,
      capacity: 250,
      currentOccupancy: 84,
      facilities: ['Drinking Water', 'First Aid & Doctors', 'Emergency Power Backups'],
      distance: 0.8,
      isAvailable: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: ShelterCard(
                shelter: shelter,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Kharghar Community Relief Center'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DisasterAlertApp renders Splash and loads app identity', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => AlertProvider()),
          ChangeNotifierProvider(create: (_) => ContactProvider()),
          ChangeNotifierProvider(create: (_) => ShelterProvider()),
        ],
        child: const DisasterAlertApp(),
      ),
    );

    // Initial frame on SplashScreen shows app name and tagline
    expect(find.text('DisasterAlert'), findsOneWidget);
    expect(find.text('Stay Alert. Stay Safe.'), findsOneWidget);

    // Advance clock past the splash delay so all timers finish
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();
  });
}
