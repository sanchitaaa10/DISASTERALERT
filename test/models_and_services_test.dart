import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_alert/models/alert.dart';
import 'package:disaster_alert/models/shelter.dart';
import 'package:disaster_alert/models/first_aid.dart';
import 'package:disaster_alert/utils/validators.dart';
import 'package:disaster_alert/utils/helpers.dart';
import 'package:disaster_alert/services/alert_service.dart';
import 'package:disaster_alert/services/shelter_service.dart';

void main() {
  group('AlertModel & AlertService Tests', () {
    test('AlertModel properties and severity colors are properly formatted', () {
      final alert = AlertModel(
        id: 'test_1',
        title: 'Test Earthquake',
        type: DisasterType.earthquake,
        description: 'Test tremor near Kharghar',
        severity: AlertSeverity.critical,
        location: 'Kharghar',
        timestamp: DateTime.now(),
        safetyInstructions: ['Stay calm', 'Drop and cover'],
      );

      expect(alert.severityLabel, 'CRITICAL');
      expect(alert.typeDisplayName, 'Earthquake');
      expect(alert.isActive, isTrue);
      expect(alert.safetyInstructions.length, 2);
    });

    test('AlertService filters by severity and active state', () {
      final service = AlertService();
      final all = service.getAlerts();
      expect(all.length, greaterThanOrEqualTo(8));

      final criticals = service.filterAlerts(severity: AlertSeverity.critical);
      for (final a in criticals) {
        expect(a.severity, AlertSeverity.critical);
      }

      final searchResults = service.filterAlerts(query: 'Panvel');
      expect(searchResults.isNotEmpty, isTrue);
    });

    test('AlertService simulation adds new alert to top', () {
      final service = AlertService();
      final beforeCount = service.getAlerts().length;
      final simulated = service.simulateIncomingAlert();

      expect(service.getAlerts().length, beforeCount + 1);
      expect(service.getAlerts().first.id, simulated.id);
    });
  });

  group('ShelterModel & ShelterService Tests', () {
    test('Shelter occupancy rate and available spots are accurate', () {
      const shelter = Shelter(
        id: 's_test',
        name: 'Test Hall',
        address: 'Test Road',
        latitude: 19.04,
        longitude: 73.06,
        distance: 1.5,
        capacity: 100,
        currentOccupancy: 80,
        facilities: ['Drinking Water', 'Medical'],
        isAvailable: true,
        contactNumber: '112',
      );

      expect(shelter.availableSpots, 20);
      expect(shelter.occupancyRate, 0.8);
      expect(shelter.occupancyStatusText, 'AVAILABLE');
    });

    test('ShelterService filters and sorts shelters by proximity', () {
      final service = ShelterService();
      final shelters = service.getShelters();
      expect(shelters.length, greaterThanOrEqualTo(8));

      // Sorted ascending by distance
      for (int i = 0; i < shelters.length - 1; i++) {
        expect(shelters[i].distance, lessThanOrEqualTo(shelters[i + 1].distance));
      }

      final filteredWater = service.filterShelters(requiredFacility: 'Water');
      expect(filteredWater.isNotEmpty, isTrue);
    });
  });

  group('AppValidators Tests', () {
    test('validateName validates minimum characters and non-empty', () {
      expect(AppValidators.validateName(null), isNotNull);
      expect(AppValidators.validateName(''), isNotNull);
      expect(AppValidators.validateName('A'), isNotNull);
      expect(AppValidators.validateName('Sanchita'), isNull);
    });

    test('validatePhone validates 10-digit requirements', () {
      expect(AppValidators.validatePhone(null), isNotNull);
      expect(AppValidators.validatePhone('12345'), isNotNull);
      expect(AppValidators.validatePhone('9820112345'), isNull);
      expect(AppValidators.validatePhone('+91 98201 12345'), isNull);
    });
  });

  group('AppHelpers Haversine Distance Tests', () {
    test('Calculates distance between coordinates accurately', () {
      // Kharghar (19.0473, 73.0699) to Vashi (19.0771, 72.9986) ~ 8-10 km
      final dist = AppHelpers.calculateDistanceKm(19.0473, 73.0699, 19.0771, 72.9986);
      expect(dist, greaterThan(6.0));
      expect(dist, lessThan(15.0));
    });
  });

  group('FirstAid Model Tests', () {
    test('FirstAid categories and steps', () {
      const guide = FirstAid(
        id: 'fa_test',
        title: 'Test Wound',
        category: FirstAidCategory.trauma,
        iconKey: 'bleeding',
        shortDescription: 'Press firmly',
        whenItHappens: 'During collapse',
        steps: ['Step 1', 'Step 2'],
        whatNotToDo: ['Do not rub'],
        whenToSeekHelp: 'Immediately',
      );

      expect(guide.categoryName, 'Trauma & Physical');
      expect(guide.steps.length, 2);
      expect(guide.emergencyNumber, '108');
    });
  });
}
