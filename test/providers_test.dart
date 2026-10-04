import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_alert/models/alert.dart';
import 'package:disaster_alert/providers/alert_provider.dart';
import 'package:disaster_alert/providers/notification_provider.dart';
import 'package:disaster_alert/providers/shelter_provider.dart';

void main() {
  group('AlertProvider Tests', () {
    test('Initial state loads alerts and computes threat level', () {
      final provider = AlertProvider();
      expect(provider.allAlerts.length, greaterThanOrEqualTo(8));
      expect(provider.overallThreatLevel, isNotEmpty);
      expect(provider.criticalAlertsCount, greaterThan(0));
    });

    test('Filter by severity updates filtered list', () {
      final provider = AlertProvider();
      provider.setSeverityFilter(AlertSeverity.critical);
      for (final a in provider.filteredAlerts) {
        expect(a.severity, AlertSeverity.critical);
      }

      provider.clearFilters();
      expect(provider.selectedSeverity, isNull);
      expect(provider.filteredAlerts.length, provider.allAlerts.length);
    });

    test('Simulating alert dispatches notification and updates counts', () {
      final alertProvider = AlertProvider();
      final notifProvider = NotificationProvider();

      final beforeNotifCount = notifProvider.notifications.length;
      final beforeAlertCount = alertProvider.allAlerts.length;

      alertProvider.triggerSimulatedAlert(notifProvider);

      expect(alertProvider.allAlerts.length, beforeAlertCount + 1);
      expect(notifProvider.notifications.length, beforeNotifCount + 1);
    });
  });

  group('ShelterProvider Tests', () {
    test('Calculates available shelters and spots correctly', () {
      final provider = ShelterProvider();
      expect(provider.allShelters.length, greaterThanOrEqualTo(8));
      expect(provider.availableSheltersCount, greaterThan(0));
      expect(provider.totalAvailableCapacity, greaterThan(0));
    });

    test('Filter by onlyAvailable removes full shelters', () {
      final provider = ShelterProvider();
      provider.toggleOnlyAvailable(true);
      for (final s in provider.filteredShelters) {
        expect(s.isAvailable, isTrue);
        expect(s.availableSpots, greaterThan(0));
      }
    });
  });

  group('NotificationProvider Tests', () {
    test('Unread count and mark as read functionality', () {
      final provider = NotificationProvider();
      expect(provider.unreadCount, greaterThan(0));

      final firstUnread = provider.notifications.firstWhere((n) => !n.isRead);
      provider.markAsRead(firstUnread.id);

      final updated = provider.notifications.firstWhere((n) => n.id == firstUnread.id);
      expect(updated.isRead, isTrue);

      provider.markAllAsRead();
      expect(provider.unreadCount, 0);
    });
  });
}
