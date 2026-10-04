import 'package:flutter/material.dart';

enum EmergencyContactType {
  police,
  fire,
  ambulance,
  disasterManagement,
  womenHelpline,
  childHelpline,
  ndrf,
  general,
}

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final EmergencyContactType type;
  final String description;
  final String iconKey;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.description,
    this.iconKey = 'call',
  });

  IconData get icon {
    switch (type) {
      case EmergencyContactType.police:
        return Icons.local_police_rounded;
      case EmergencyContactType.fire:
        return Icons.local_fire_department_rounded;
      case EmergencyContactType.ambulance:
        return Icons.medical_services_rounded;
      case EmergencyContactType.disasterManagement:
        return Icons.shield_rounded;
      case EmergencyContactType.womenHelpline:
        return Icons.support_agent_rounded;
      case EmergencyContactType.childHelpline:
        return Icons.family_restroom_rounded;
      case EmergencyContactType.ndrf:
        return Icons.military_tech_rounded;
      case EmergencyContactType.general:
        return Icons.phone_in_talk_rounded;
    }
  }

  Color get categoryColor {
    switch (type) {
      case EmergencyContactType.police:
        return const Color(0xFF1565C0); // Deep Blue
      case EmergencyContactType.fire:
        return const Color(0xFFD84315); // Deep Flame Orange
      case EmergencyContactType.ambulance:
        return const Color(0xFFC62828); // Medical Red
      case EmergencyContactType.disasterManagement:
        return const Color(0xFF00838F); // Teal
      case EmergencyContactType.womenHelpline:
        return const Color(0xFFAD1457); // Purple Rose
      case EmergencyContactType.childHelpline:
        return const Color(0xFF2E7D32); // Forest Green
      case EmergencyContactType.ndrf:
        return const Color(0xFFEF6C00); // Alert Orange
      case EmergencyContactType.general:
        return const Color(0xFF455A64); // Slate
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'type': type.name,
      'description': description,
      'iconKey': iconKey,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      type: EmergencyContactType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EmergencyContactType.general,
      ),
      description: json['description'] as String,
      iconKey: json['iconKey'] as String? ?? 'call',
    );
  }
}
