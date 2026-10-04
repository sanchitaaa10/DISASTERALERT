import '../models/notification_model.dart';

final List<NotificationModel> kMockNotifications = [
  NotificationModel(
    id: 'notif_001',
    title: 'Earthquake Tremor Alert (M 4.8)',
    description:
        'Seismic tremor recorded in Kharghar-Panvel fault corridor. Stay alert for aftershocks. Check gas line connections.',
    type: NotificationType.emergencyAlert,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    isRead: false,
    relatedEntityId: 'alert_001',
  ),
  NotificationModel(
    id: 'notif_002',
    title: 'Shelter Capacity Update: Kharghar Center',
    description:
        'Kharghar Community Relief Center (0.8 km) currently has 166 beds available with medical staff on standby.',
    type: NotificationType.shelterUpdate,
    timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
    isRead: false,
    relatedEntityId: 'shelter_001',
  ),
  NotificationModel(
    id: 'notif_003',
    title: 'Flash Flood Watch: Panvel Lowlands',
    description:
        'Gadhi River gauge crossed warning level. Avoid low-lying underpasses and bridges near Old Panvel.',
    type: NotificationType.emergencyAlert,
    timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
    isRead: false,
    relatedEntityId: 'alert_002',
  ),
  NotificationModel(
    id: 'notif_004',
    title: 'Safety Check: Monsoon Health Advisory',
    description:
        'Boil all tap water for at least 3 minutes before drinking. Free water purification tablets available at shelters.',
    type: NotificationType.safetyReminder,
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
    isRead: true,
  ),
  NotificationModel(
    id: 'notif_005',
    title: 'Chemical Vapor Plume Cordoning',
    description:
        'Hazardous vapor containment at Taloja MIDC is 85% controlled. Air quality index monitors active.',
    type: NotificationType.emergencyAlert,
    timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
    isRead: true,
    relatedEntityId: 'alert_004',
  ),
  NotificationModel(
    id: 'notif_006',
    title: 'Seawoods Transit Camp Reached Capacity',
    description:
        'Seawoods Grand Transit Camp is now at maximum capacity (300/300). Evacuees are being redirected to Belapur Arena.',
    type: NotificationType.shelterUpdate,
    timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    isRead: true,
    relatedEntityId: 'shelter_006',
  ),
  NotificationModel(
    id: 'notif_007',
    title: 'Emergency Contact Network Synchronized',
    description:
        'Your trusted contacts (5 registered) are synchronized. 1-tap SOS distress broadcasts are armed.',
    type: NotificationType.systemNotification,
    timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    isRead: true,
  ),
  NotificationModel(
    id: 'notif_008',
    title: 'Parsik Hill Geological Alert',
    description:
        'Rockfall hazard monitoring installed. Commuters directed to CBD Belapur main arterial corridor.',
    type: NotificationType.emergencyAlert,
    timestamp: DateTime.now().subtract(const Duration(hours: 8)),
    isRead: true,
    relatedEntityId: 'alert_005',
  ),
  NotificationModel(
    id: 'notif_009',
    title: 'First-Aid Kit Audit Checklist',
    description:
        'Ensure your domestic first-aid kit contains clean bandages, antiseptic liquid, ORS sachets, and torch batteries.',
    type: NotificationType.safetyReminder,
    timestamp: DateTime.now().subtract(const Duration(hours: 14)),
    isRead: true,
  ),
  NotificationModel(
    id: 'notif_010',
    title: 'DisasterAlert Network Initialized',
    description:
        'Welcome to DisasterAlert. Real-time emergency detection and early warning radar services are online for Kharghar.',
    type: NotificationType.systemNotification,
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
];
