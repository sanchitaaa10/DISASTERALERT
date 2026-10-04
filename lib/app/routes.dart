import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../models/first_aid.dart';
import '../models/shelter.dart';
import '../screens/alerts/alert_detail_screen.dart';
import '../screens/alerts/alert_feed_screen.dart';
import '../screens/alerts/report_hazard_screen.dart';
import '../screens/contacts/emergency_contacts_screen.dart';
import '../screens/contacts/trusted_contacts_screen.dart';
import '../screens/first_aid/first_aid_detail_screen.dart';
import '../screens/first_aid/first_aid_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/shelters/shelter_detail_screen.dart';
import '../screens/shelters/shelter_locator_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/survival/survival_kit_screen.dart';
import '../screens/tools/rescue_beacon_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String mainNav = '/main';
  static const String alerts = '/alerts';
  static const String alertDetails = '/alert-details';
  static const String emergencyContacts = '/emergency-contacts';
  static const String trustedContacts = '/trusted-contacts';
  static const String shelters = '/shelters';
  static const String shelterDetails = '/shelter-details';
  static const String firstAid = '/first-aid';
  static const String firstAidDetails = '/first-aid-details';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String survivalKit = '/survival-kit';
  static const String rescueBeacon = '/rescue-beacon';
  static const String reportHazard = '/report-hazard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case mainNav:
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainNavigationScreen(initialIndex: initialIndex),
        );
      case alerts:
        return MaterialPageRoute(builder: (_) => const AlertFeedScreen());
      case alertDetails:
        final alert = settings.arguments as AlertModel;
        return MaterialPageRoute(
          builder: (_) => AlertDetailScreen(alert: alert),
        );
      case emergencyContacts:
        return MaterialPageRoute(builder: (_) => const EmergencyContactsScreen());
      case trustedContacts:
        return MaterialPageRoute(builder: (_) => const TrustedContactsScreen());
      case shelters:
        return MaterialPageRoute(builder: (_) => const ShelterLocatorScreen());
      case shelterDetails:
        final shelter = settings.arguments as Shelter;
        return MaterialPageRoute(
          builder: (_) => ShelterDetailScreen(shelter: shelter),
        );
      case firstAid:
        return MaterialPageRoute(builder: (_) => const FirstAidScreen());
      case firstAidDetails:
        final guide = settings.arguments as FirstAid;
        return MaterialPageRoute(
          builder: (_) => FirstAidDetailScreen(guide: guide),
        );
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case survivalKit:
        return MaterialPageRoute(builder: (_) => const SurvivalKitScreen());
      case rescueBeacon:
        return MaterialPageRoute(builder: (_) => const RescueBeaconScreen());
      case reportHazard:
        return MaterialPageRoute(builder: (_) => const ReportHazardScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
