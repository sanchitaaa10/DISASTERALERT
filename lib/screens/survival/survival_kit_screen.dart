import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/survival_item.dart';
import '../../providers/survival_kit_provider.dart';
import '../../utils/constants.dart';

class SurvivalKitScreen extends StatelessWidget {
  const SurvivalKitScreen({super.key});

  void _showAddItemDialog(BuildContext context, SurvivalKitProvider provider) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    SurvivalCategory selectedCategory = SurvivalCategory.waterAndFood;
    bool isEssential = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            title: const Text('Add Custom Gear'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      hintText: 'e.g. Baby formula, Inhaler, Pet food',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notes / Quantity',
                      hintText: 'e.g. 2 cans, 3-day dose',
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<SurvivalCategory>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: SurvivalCategory.values.map((cat) {
                      String label;
                      switch (cat) {
                        case SurvivalCategory.waterAndFood:
                          label = 'Water & Rations';
                          break;
                        case SurvivalCategory.medical:
                          label = 'Medical & Trauma';
                          break;
                        case SurvivalCategory.toolsAndSignaling:
                          label = 'Tools & Signaling';
                          break;
                        case SurvivalCategory.powerAndDocuments:
                          label = 'Power & Documents';
                          break;
                      }
                      return DropdownMenuItem(value: cat, child: Text(label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: const Text('Mark as Essential', style: TextStyle(fontSize: 14)),
                    value: isEssential,
                    activeColor: isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => isEssential = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isNotEmpty) {
                    provider.addItem(
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty ? 'Personalized survival gear' : descCtrl.text.trim(),
                      category: selectedCategory,
                      isEssential: isEssential,
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Add Gear'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SurvivalKitProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = provider.filteredItems;
    final readiness = provider.readinessScore;

    Color progressColor;
    if (readiness >= 80) {
      progressColor = isDark ? AppColorsDark.safeGreen : AppColors.safeGreen;
    } else if (readiness >= 50) {
      progressColor = isDark ? AppColorsDark.warningOrange : AppColors.warningOrange;
    } else {
      progressColor = isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evacuation "Go-Bag"'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Packing Status',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset Checklist?'),
                  content: const Text('This will uncheck all items in your survival kit.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        provider.resetAll();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Custom Item'),
        onPressed: () => _showAddItemDialog(context, provider),
      ),
      body: Column(
        children: [
          // Readiness Progress Banner
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColorsDark.surface : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.backpack_rounded, color: progressColor, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Evacuation Readiness',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: progressColor.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        '$readiness% READY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: progressColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: provider.readinessPercentage,
                    minHeight: 10,
                    backgroundColor: isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.packedCount} of ${provider.totalCount} items packed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      readiness >= 100 ? 'Go-Bag is fully ready!' : 'Keep ready near your exit door',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  label: 'All Items',
                  isSelected: provider.selectedCategory == null,
                  onSelected: () => provider.setCategoryFilter(null),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Water & Food',
                  isSelected: provider.selectedCategory == SurvivalCategory.waterAndFood,
                  onSelected: () => provider.setCategoryFilter(SurvivalCategory.waterAndFood),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Medical',
                  isSelected: provider.selectedCategory == SurvivalCategory.medical,
                  onSelected: () => provider.setCategoryFilter(SurvivalCategory.medical),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Tools & Whistle',
                  isSelected: provider.selectedCategory == SurvivalCategory.toolsAndSignaling,
                  onSelected: () => provider.setCategoryFilter(SurvivalCategory.toolsAndSignaling),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Power & Docs',
                  isSelected: provider.selectedCategory == SurvivalCategory.powerAndDocuments,
                  onSelected: () => provider.setCategoryFilter(SurvivalCategory.powerAndDocuments),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Items List
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'No items in this category.',
                      style: TextStyle(
                        color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      top: 4,
                      bottom: 80,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        color: isDark ? AppColorsDark.surface : AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          side: BorderSide(
                            color: item.isPacked
                                ? (isDark ? AppColorsDark.safeGreen.withOpacity(0.4) : AppColors.safeGreen.withOpacity(0.4))
                                : (isDark ? AppColorsDark.border : AppColors.border),
                          ),
                        ),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          activeColor: isDark ? AppColorsDark.safeGreen : AppColors.safeGreen,
                          value: item.isPacked,
                          onChanged: (_) => provider.toggleItemPacked(item.id),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    decoration: item.isPacked ? TextDecoration.lineThrough : null,
                                    color: item.isPacked
                                        ? (isDark ? AppColorsDark.textMuted : AppColors.textMuted)
                                        : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                                  ),
                                ),
                              ),
                              if (item.isEssential)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'ESSENTIAL',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.35,
                                color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selBg = isDark ? AppColorsDark.emergencyRed.withOpacity(0.2) : AppColors.emergencyRed.withOpacity(0.12);
    final selText = isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? selText : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
      ),
      backgroundColor: isDark ? AppColorsDark.surface : AppColors.surface,
      selectedColor: selBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        side: BorderSide(
          color: isSelected ? selText : (isDark ? AppColorsDark.border : AppColors.border),
        ),
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
