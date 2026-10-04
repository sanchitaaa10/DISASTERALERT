import 'package:flutter/material.dart';

class Shelter {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance; // in km
  final int capacity;
  final int currentOccupancy;
  final List<String> facilities;
  final bool isAvailable;
  final String contactNumber;
  final String openingStatus;
  final String shelterType;

  const Shelter({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.capacity,
    required this.currentOccupancy,
    required this.facilities,
    required this.isAvailable,
    required this.contactNumber,
    this.openingStatus = '24/7 Active Relief Center',
    this.shelterType = 'Community Disaster Refuge',
  });

  int get availableSpots => capacity - currentOccupancy;

  double get occupancyRate => capacity > 0 ? (currentOccupancy / capacity) : 0.0;

  String get occupancyStatusText {
    if (!isAvailable || availableSpots <= 0) {
      return 'FULL / UNAVAILABLE';
    } else if (occupancyRate > 0.85) {
      return 'NEAR CAPACITY';
    } else {
      return 'AVAILABLE';
    }
  }

  Color get occupancyColor {
    if (!isAvailable || availableSpots <= 0) {
      return const Color(0xFFD32F2F); // Red
    } else if (occupancyRate > 0.85) {
      return const Color(0xFFF57C00); // Orange
    } else {
      return const Color(0xFF2E7D32); // Green
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'capacity': capacity,
      'currentOccupancy': currentOccupancy,
      'facilities': facilities,
      'isAvailable': isAvailable,
      'contactNumber': contactNumber,
      'openingStatus': openingStatus,
      'shelterType': shelterType,
    };
  }

  factory Shelter.fromJson(Map<String, dynamic> json) {
    return Shelter(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      capacity: json['capacity'] as int,
      currentOccupancy: json['currentOccupancy'] as int,
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      contactNumber: json['contactNumber'] as String? ?? '112',
      openingStatus: json['openingStatus'] as String? ?? '24/7 Active',
      shelterType: json['shelterType'] as String? ?? 'Community Relief Center',
    );
  }

  Shelter copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? distance,
    int? capacity,
    int? currentOccupancy,
    List<String>? facilities,
    bool? isAvailable,
    String? contactNumber,
    String? openingStatus,
    String? shelterType,
  }) {
    return Shelter(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      capacity: capacity ?? this.capacity,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      facilities: facilities ?? this.facilities,
      isAvailable: isAvailable ?? this.isAvailable,
      contactNumber: contactNumber ?? this.contactNumber,
      openingStatus: openingStatus ?? this.openingStatus,
      shelterType: shelterType ?? this.shelterType,
    );
  }
}
