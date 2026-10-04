class TrustedContact {
  final String id;
  final String name;
  final String relationship;
  final String phone;
  final bool isPrimary;
  final String? notes;

  const TrustedContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    this.isPrimary = false,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'phone': phone,
      'isPrimary': isPrimary,
      'notes': notes,
    };
  }

  factory TrustedContact.fromJson(Map<String, dynamic> json) {
    return TrustedContact(
      id: json['id'] as String,
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  TrustedContact copyWith({
    String? id,
    String? name,
    String? relationship,
    String? phone,
    bool? isPrimary,
    String? notes,
  }) {
    return TrustedContact(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      isPrimary: isPrimary ?? this.isPrimary,
      notes: notes ?? this.notes,
    );
  }
}
