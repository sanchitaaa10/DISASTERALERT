import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../utils/constants.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;
  final bool isLarge;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
    this.isLarge = false,
  });

  factory StatusBadge.fromSeverity(AlertSeverity severity, {bool isLarge = false}) {
    String label;
    Color color;
    Color bg;
    IconData icon;

    switch (severity) {
      case AlertSeverity.critical:
        label = 'CRITICAL';
        color = AppColors.emergencyRed;
        bg = AppColors.emergencyRedSurface;
        icon = Icons.error_outline_rounded;
        break;
      case AlertSeverity.high:
        label = 'HIGH';
        color = AppColors.warningOrange;
        bg = AppColors.warningOrangeSurface;
        icon = Icons.warning_amber_rounded;
        break;
      case AlertSeverity.medium:
        label = 'MEDIUM';
        color = const Color(0xFFC79200); // High contrast amber
        bg = const Color(0xFFFFFBEA);
        icon = Icons.info_outline_rounded;
        break;
      case AlertSeverity.low:
        label = 'ADVISORY';
        color = AppColors.safeGreen;
        bg = AppColors.safeGreenSurface;
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return StatusBadge(
      label: label,
      color: color,
      backgroundColor: bg,
      icon: icon,
      isLarge: isLarge,
    );
  }

  factory StatusBadge.safe({String text = 'SAFE', bool isLarge = false}) {
    return StatusBadge(
      label: text,
      color: AppColors.safeGreen,
      backgroundColor: AppColors.safeGreenSurface,
      icon: Icons.shield_rounded,
      isLarge: isLarge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 8,
        vertical: isLarge ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isLarge ? 16 : 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: isLarge ? 12 : 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
