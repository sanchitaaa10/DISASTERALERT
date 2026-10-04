import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
    this.iconColor,
  });

  factory EmptyStateWidget.safe({String message = 'No active disaster alerts in your sector.'}) {
    return EmptyStateWidget(
      icon: Icons.shield_rounded,
      iconColor: AppColors.safeGreen,
      title: "You're Safe",
      description: message,
    );
  }

  factory EmptyStateWidget.noAlerts({VoidCallback? onReset}) {
    return EmptyStateWidget(
      icon: Icons.notifications_none_rounded,
      iconColor: AppColors.textMuted,
      title: 'No Alerts Found',
      description: 'No active or archived alerts match your current filter parameters.',
      actionLabel: 'Reset Filters',
      onActionPressed: onReset,
    );
  }

  factory EmptyStateWidget.noShelters({VoidCallback? onReset}) {
    return EmptyStateWidget(
      icon: Icons.holiday_village_outlined,
      iconColor: AppColors.textMuted,
      title: 'No Shelters Matching Criteria',
      description: 'Try adjusting your maximum distance radius or clearing facility filters.',
      actionLabel: 'Show All Shelters',
      onActionPressed: onReset,
    );
  }

  factory EmptyStateWidget.noContacts({VoidCallback? onAdd}) {
    return EmptyStateWidget(
      icon: Icons.contact_emergency_outlined,
      iconColor: AppColors.textMuted,
      title: 'No Trusted Contacts Added',
      description:
          'Add your family members, friends, or roommates to receive instant SOS distress messages.',
      actionLabel: 'Add First Contact',
      onActionPressed: onAdd,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.textMuted).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: iconColor ?? AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
