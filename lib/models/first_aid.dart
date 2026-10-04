import 'package:flutter/material.dart';

enum FirstAidCategory {
  trauma,
  environmental,
  respiratory,
  cardiac,
  medical,
  burnsPoisons,
}

class FirstAid {
  final String id;
  final String title;
  final FirstAidCategory category;
  final String iconKey;
  final String shortDescription;
  final String whenItHappens;
  final List<String> steps;
  final List<String> whatNotToDo;
  final String whenToSeekHelp;
  final String emergencyNumber;

  const FirstAid({
    required this.id,
    required this.title,
    required this.category,
    required this.iconKey,
    required this.shortDescription,
    required this.whenItHappens,
    required this.steps,
    required this.whatNotToDo,
    required this.whenToSeekHelp,
    this.emergencyNumber = '108',
  });

  String get categoryName {
    switch (category) {
      case FirstAidCategory.trauma:
        return 'Trauma & Physical';
      case FirstAidCategory.environmental:
        return 'Environmental Hazard';
      case FirstAidCategory.respiratory:
        return 'Airway & Breathing';
      case FirstAidCategory.cardiac:
        return 'Cardiovascular';
      case FirstAidCategory.medical:
        return 'General Medical & Fainting';
      case FirstAidCategory.burnsPoisons:
        return 'Burns & Toxins';
    }
  }

  IconData get icon {
    switch (iconKey) {
      case 'bleeding':
        return Icons.water_drop_rounded;
      case 'burns':
        return Icons.local_fire_department_rounded;
      case 'fractures':
        return Icons.healing_rounded;
      case 'cpr':
        return Icons.favorite_rounded;
      case 'fainting':
        return Icons.airline_seat_flat_rounded;
      case 'snakeBite':
        return Icons.pest_control_rounded;
      case 'electricShock':
        return Icons.bolt_rounded;
      case 'heatStroke':
        return Icons.thermostat_rounded;
      case 'choking':
        return Icons.air_rounded;
      case 'dehydration':
        return Icons.opacity_rounded;
      default:
        return Icons.medical_services_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case FirstAidCategory.trauma:
        return const Color(0xFFC62828); // Red
      case FirstAidCategory.environmental:
        return const Color(0xFFE65100); // Orange
      case FirstAidCategory.respiratory:
        return const Color(0xFF0277BD); // Light Blue
      case FirstAidCategory.cardiac:
        return const Color(0xFF880E4F); // Wine Red
      case FirstAidCategory.medical:
        return const Color(0xFF00897B); // Teal Green
      case FirstAidCategory.burnsPoisons:
        return const Color(0xFF6A1B9A); // Deep Purple
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'iconKey': iconKey,
      'shortDescription': shortDescription,
      'whenItHappens': whenItHappens,
      'steps': steps,
      'whatNotToDo': whatNotToDo,
      'whenToSeekHelp': whenToSeekHelp,
      'emergencyNumber': emergencyNumber,
    };
  }

  factory FirstAid.fromJson(Map<String, dynamic> json) {
    return FirstAid(
      id: json['id'] as String,
      title: json['title'] as String,
      category: FirstAidCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => FirstAidCategory.trauma,
      ),
      iconKey: json['iconKey'] as String,
      shortDescription: json['shortDescription'] as String,
      whenItHappens: json['whenItHappens'] as String,
      steps: (json['steps'] as List<dynamic>).map((e) => e.toString()).toList(),
      whatNotToDo: (json['whatNotToDo'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      whenToSeekHelp: json['whenToSeekHelp'] as String,
      emergencyNumber: json['emergencyNumber'] as String? ?? '108',
    );
  }
}
