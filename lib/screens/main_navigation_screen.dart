import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alert_provider.dart';
import '../utils/constants.dart';
import 'alerts/alert_feed_screen.dart';
import 'first_aid/first_aid_screen.dart';
import 'home/dashboard_screen.dart';
import 'profile/profile_screen.dart';
import 'shelters/shelter_locator_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    final activeAlerts = alertProvider.activeAlertsCount;

    final screens = [
      DashboardScreen(onNavigateTab: _navigateToTab),
      AlertFeedScreen(onNavigateTab: _navigateToTab),
      const ShelterLocatorScreen(),
      const FirstAidScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _navigateToTab,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: activeAlerts > 0,
              label: Text('$activeAlerts'),
              backgroundColor: AppColors.emergencyRed,
              child: const Icon(Icons.crisis_alert_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: activeAlerts > 0,
              label: Text('$activeAlerts'),
              backgroundColor: AppColors.emergencyRed,
              child: const Icon(Icons.crisis_alert_rounded),
            ),
            label: 'Alerts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.holiday_village_outlined),
            selectedIcon: Icon(Icons.holiday_village_rounded),
            label: 'Shelters',
          ),
          const NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety_rounded),
            label: 'First Aid',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
