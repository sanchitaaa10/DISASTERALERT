enum SurvivalCategory {
  waterAndFood,
  medical,
  toolsAndSignaling,
  powerAndDocuments,
}

class SurvivalItem {
  final String id;
  final String title;
  final String description;
  final SurvivalCategory category;
  final bool isEssential;
  bool isPacked;

  SurvivalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isEssential = true,
    this.isPacked = false,
  });

  String get categoryName {
    switch (category) {
      case SurvivalCategory.waterAndFood:
        return 'Water & Rations';
      case SurvivalCategory.medical:
        return 'Medical & Trauma';
      case SurvivalCategory.toolsAndSignaling:
        return 'Tools & Signaling';
      case SurvivalCategory.powerAndDocuments:
        return 'Power & Documents';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'isEssential': isEssential,
        'isPacked': isPacked,
      };

  factory SurvivalItem.fromJson(Map<String, dynamic> json) => SurvivalItem(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: SurvivalCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => SurvivalCategory.waterAndFood,
        ),
        isEssential: json['isEssential'] as bool? ?? true,
        isPacked: json['isPacked'] as bool? ?? false,
      );
}
