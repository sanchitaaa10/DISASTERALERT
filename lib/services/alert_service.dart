import 'dart:math';
import '../models/alert.dart';
import '../data/mock_alerts.dart';

class AlertService {
  List<AlertModel> _alerts = List.from(kMockAlerts);

  List<AlertModel> getAlerts() {
    return List.unmodifiable(_alerts);
  }

  void addAlert(AlertModel alert) {
    _alerts.insert(0, alert);
  }

  AlertModel? getAlertById(String id) {
    try {
      return _alerts.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  AlertModel? getLatestActiveAlert() {
    try {
      return _alerts.firstWhere((a) => a.isActive);
    } catch (_) {
      return _alerts.isNotEmpty ? _alerts.first : null;
    }
  }

  /// Filter alerts based on search query, severity, and active filter
  List<AlertModel> filterAlerts({
    String query = '',
    AlertSeverity? severity,
    bool? onlyActive,
  }) {
    return _alerts.where((alert) {
      if (onlyActive != null && onlyActive && !alert.isActive) {
        return false;
      }
      if (severity != null && alert.severity != severity) {
        return false;
      }
      if (query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        final matchesTitle = alert.title.toLowerCase().contains(q);
        final matchesDesc = alert.description.toLowerCase().contains(q);
        final matchesLoc = alert.location.toLowerCase().contains(q);
        final matchesType = alert.typeDisplayName.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDesc && !matchesLoc && !matchesType) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Simulate a realistic incoming disaster alert for demonstration
  AlertModel simulateIncomingAlert() {
    final random = Random();
    final scenarios = [
      AlertModel(
        id: 'sim_alert_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Severe Thunderstorm & Flash Cloudburst',
        type: DisasterType.severeStorm,
        description:
            'Rapid convective thunderclouds detected directly above Kharghar Hills and Panvel. Extreme lightning strikes and localized water accumulation expected within the next 20 minutes.',
        severity: AlertSeverity.critical,
        location: 'Kharghar Sectors 20-35 & Taloja Foothills',
        timestamp: DateTime.now(),
        isActive: true,
        affectedRadiusKm: 14.0,
        safetyInstructions: [
          'Seek immediate substantial indoor shelter. Do not take cover under isolated trees.',
          'Unplug sensitive electrical equipment to protect against surges.',
          'Stay away from tin-roofed sheds and metal poles.',
          'Avoid driving on waterlogged stretches along the Sion-Panvel Highway.',
        ],
        source: 'Doppler Weather Radar, Mumbai IMD Alert',
      ),
      AlertModel(
        id: 'sim_alert_${DateTime.now().millisecondsSinceEpoch}',
        title: 'High-Level River Surge Advisory',
        type: DisasterType.flood,
        description:
            'Upstream dam spillway gates opened at Morbe Dam following catchment downpour. River discharge into the Gadhi basin will peak by late afternoon.',
        severity: AlertSeverity.high,
        location: 'Panvel River Basin & Khandeshwar Flats',
        timestamp: DateTime.now(),
        isActive: true,
        affectedRadiusKm: 22.0,
        safetyInstructions: [
          'Move livestock, vehicles, and equipment to higher terrace elevations.',
          'Avoid the causeway and bridge crossings.',
          'Follow NDRF safety sirens along river embankments.',
        ],
        source: 'Irrigation Department & District Collectorate',
      ),
      AlertModel(
        id: 'sim_alert_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Aftershock Tremor Advisory (M 3.9)',
        type: DisasterType.earthquake,
        description:
            'A secondary aftershock tremor was logged 12 km East of Kharghar. While structural compromise is minimal, residents should remain alert for vibrations.',
        severity: AlertSeverity.medium,
        location: 'Kharghar, Belapur & Nerul Corridor',
        timestamp: DateTime.now(),
        isActive: true,
        affectedRadiusKm: 16.0,
        safetyInstructions: [
          'Keep exit doorways unblocked.',
          'Ensure gas regulator valves remain shut off when not in use.',
          'Check in with your designated trusted contacts.',
        ],
        source: 'National Seismological Network',
      ),
    ];

    final newAlert = scenarios[random.nextInt(scenarios.length)];
    // Prepend to top of list
    _alerts = [newAlert, ..._alerts];
    return newAlert;
  }
}
