import 'package:flutter/material.dart';

enum NotificationType {
  emergencyAlert,
  shelterUpdate,
  systemNotification,
  safetyReminder,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedEntityId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedEntityId,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.emergencyAlert:
        return Icons.crisis_alert_rounded;
      case NotificationType.shelterUpdate:
        return Icons.holiday_village_rounded;
      case NotificationType.systemNotification:
        return Icons.info_outline_rounded;
      case NotificationType.safetyReminder:
        return Icons.health_and_safety_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.emergencyAlert:
        return const Color(0xFFD32F2F);
      case NotificationType.shelterUpdate:
        return const Color(0xFF0288D1);
      case NotificationType.systemNotification:
        return const Color(0xFF5E35B1);
      case NotificationType.safetyReminder:
        return const Color(0xFF388E3C);
    }
  }

  String get typeLabel {
    switch (type) {
      case NotificationType.emergencyAlert:
        return 'Emergency Alert';
      case NotificationType.shelterUpdate:
        return 'Shelter Status';
      case NotificationType.systemNotification:
        return 'System Advisory';
      case NotificationType.safetyReminder:
        return 'Safety Protocol';
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? relatedEntityId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'relatedEntityId': relatedEntityId,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.systemNotification,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      relatedEntityId: json['relatedEntityId'] as String?,
    );
  }
}
