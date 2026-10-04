import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;
  final Color? activeColor;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = activeColor ?? AppColors.emergencyRed;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        avatar: icon != null
            ? Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              )
            : null,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        selectedColor: effectiveColor,
        side: BorderSide(
          color: isSelected ? effectiveColor : AppColors.border,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        onSelected: onSelected,
      ),
    );
  }
}
