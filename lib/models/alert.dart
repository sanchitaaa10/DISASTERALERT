import 'package:flutter/material.dart';

enum DisasterType {
  earthquake,
  flood,
  cyclone,
  fire,
  landslide,
  tsunami,
  heatwave,
  gasLeak,
  severeStorm,
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low,
}

class AlertModel {
  final String id;
  final String title;
  final DisasterType type;
  final String description;
  final AlertSeverity severity;
  final String location;
  final DateTime timestamp;
  final bool isActive;
  final double affectedRadiusKm;
  final List<String> safetyInstructions;
  final String source;

  const AlertModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.severity,
    required this.location,
    required this.timestamp,
    this.isActive = true,
    this.affectedRadiusKm = 15.0,
    required this.safetyInstructions,
    this.source = 'National Disaster Management Authority (NDMA)',
  });

  String get severityLabel {
    switch (severity) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.high:
        return 'HIGH';
      case AlertSeverity.medium:
        return 'MEDIUM';
      case AlertSeverity.low:
        return 'LOW';
    }
  }

  Color get severityColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFD32F2F); // Deep Emergency Red
      case AlertSeverity.high:
        return const Color(0xFFF57C00); // High Warning Orange
      case AlertSeverity.medium:
        return const Color(0xFFFBC02D); // Medium Caution Amber
      case AlertSeverity.low:
        return const Color(0xFF388E3C); // Low Green / Advisory
    }
  }

  Color get severityBackgroundColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFFFEBEE);
      case AlertSeverity.high:
        return const Color(0xFFFFF3E0);
      case AlertSeverity.medium:
        return const Color(0xFFFFFDE7);
      case AlertSeverity.low:
        return const Color(0xFFE8F5E9);
    }
  }

  IconData get typeIcon {
    switch (type) {
      case DisasterType.earthquake:
        return Icons.vibration_rounded;
      case DisasterType.flood:
        return Icons.water_damage_rounded;
      case DisasterType.cyclone:
        return Icons.cyclone_rounded;
      case DisasterType.fire:
        return Icons.local_fire_department_rounded;
      case DisasterType.landslide:
        return Icons.landscape_rounded;
      case DisasterType.tsunami:
        return Icons.tsunami_rounded;
      case DisasterType.heatwave:
        return Icons.wb_sunny_rounded;
      case DisasterType.gasLeak:
        return Icons.warning_amber_rounded;
      case DisasterType.severeStorm:
        return Icons.thunderstorm_rounded;
    }
  }

  String get typeDisplayName {
    switch (type) {
      case DisasterType.earthquake:
        return 'Earthquake';
      case DisasterType.flood:
        return 'Flood';
      case DisasterType.cyclone:
        return 'Cyclone';
      case DisasterType.fire:
        return 'Fire Emergency';
      case DisasterType.landslide:
        return 'Landslide';
      case DisasterType.tsunami:
        return 'Tsunami';
      case DisasterType.heatwave:
        return 'Heatwave';
      case DisasterType.gasLeak:
        return 'Gas Leak';
      case DisasterType.severeStorm:
        return 'Severe Storm';
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hr ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'description': description,
      'severity': severity.name,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
      'affectedRadiusKm': affectedRadiusKm,
      'safetyInstructions': safetyInstructions,
      'source': source,
    };
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: DisasterType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DisasterType.earthquake,
      ),
      description: json['description'] as String,
      severity: AlertSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => AlertSeverity.high,
      ),
      location: json['location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isActive: json['isActive'] as bool? ?? true,
      affectedRadiusKm: (json['affectedRadiusKm'] as num?)?.toDouble() ?? 10.0,
      safetyInstructions: (json['safetyInstructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      source: json['source'] as String? ?? 'Disaster Alert Network',
    );
  }

  AlertModel copyWith({
    String? id,
    String? title,
    DisasterType? type,
    String? description,
    AlertSeverity? severity,
    String? location,
    DateTime? timestamp,
    bool? isActive,
    double? affectedRadiusKm,
    List<String>? safetyInstructions,
    String? source,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
      affectedRadiusKm: affectedRadiusKm ?? this.affectedRadiusKm,
      safetyInstructions: safetyInstructions ?? this.safetyInstructions,
      source: source ?? this.source,
    );
  }
}
