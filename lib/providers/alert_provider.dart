import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../models/notification_model.dart';
import '../services/alert_service.dart';
import 'notification_provider.dart';

class AlertProvider extends ChangeNotifier {
  final AlertService _service = AlertService();

  String _searchQuery = '';
  AlertSeverity? _selectedSeverity;
  bool _onlyActive = false;
  bool _isLoading = false;

  String get searchQuery => _searchQuery;
  AlertSeverity? get selectedSeverity => _selectedSeverity;
  bool get onlyActive => _onlyActive;
  bool get isLoading => _isLoading;

  List<AlertModel> get allAlerts => _service.getAlerts();

  List<AlertModel> get filteredAlerts {
    return _service.filterAlerts(
      query: _searchQuery,
      severity: _selectedSeverity,
      onlyActive: _onlyActive,
    );
  }

  AlertModel? get latestAlert => _service.getLatestActiveAlert();

  int get activeAlertsCount => allAlerts.where((a) => a.isActive).length;

  int get criticalAlertsCount => allAlerts
      .where((a) => a.isActive && a.severity == AlertSeverity.critical)
      .length;

  String get overallThreatLevel {
    if (criticalAlertsCount > 0) {
      return 'CRITICAL EMERGENCY ACTIVE';
    } else if (allAlerts.any((a) => a.isActive && a.severity == AlertSeverity.high)) {
      return 'HIGH ALERT IN EFFECT';
    } else if (activeAlertsCount > 0) {
      return 'ADVISORY MONITORING ACTIVE';
    } else {
      return 'NO ACTIVE EMERGENCY';
    }
  }

  Color get overallThreatColor {
    if (criticalAlertsCount > 0) {
      return const Color(0xFFD32F2F);
    } else if (allAlerts.any((a) => a.isActive && a.severity == AlertSeverity.high)) {
      return const Color(0xFFF57C00);
    } else if (activeAlertsCount > 0) {
      return const Color(0xFFFBC02D);
    } else {
      return const Color(0xFF2E7D32);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSeverityFilter(AlertSeverity? severity) {
    _selectedSeverity = severity;
    notifyListeners();
  }

  void toggleOnlyActive(bool value) {
    _onlyActive = value;
    notifyListeners();
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedSeverity = null;
    _onlyActive = false;
    notifyListeners();
  }

  AlertModel? getAlertById(String id) {
    return _service.getAlertById(id);
  }

  /// Trigger simulated incoming emergency alert
  AlertModel triggerSimulatedAlert(NotificationProvider notificationProvider) {
    final alert = _service.simulateIncomingAlert();

    // Automatically dispatch high-priority notification
    notificationProvider.addNotification(
      NotificationModel(
        id: 'sim_notif_${DateTime.now().millisecondsSinceEpoch}',
        title: '🚨 ${alert.severityLabel}: ${alert.title}',
        description: alert.description,
        type: NotificationType.emergencyAlert,
        timestamp: DateTime.now(),
        isRead: false,
        relatedEntityId: alert.id,
      ),
    );

    notifyListeners();
    return alert;
  }

  /// Add a citizen incident or hazard report
  void addAlert(AlertModel alert, [NotificationProvider? notificationProvider]) {
    _service.addAlert(alert);
    if (notificationProvider != null) {
      notificationProvider.addNotification(
        NotificationModel(
          id: 'hazard_notif_${DateTime.now().millisecondsSinceEpoch}',
          title: '⚠️ Community Hazard Reported: ${alert.title}',
          description: '${alert.location} • Verified and added to regional emergency grid.',
          type: NotificationType.emergencyAlert,
          timestamp: DateTime.now(),
          isRead: false,
          relatedEntityId: alert.id,
        ),
      );
    }
    notifyListeners();
  }
}
