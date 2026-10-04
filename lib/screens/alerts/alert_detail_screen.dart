import 'package:flutter/material.dart';
import '../../models/alert.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/status_badge.dart';

class AlertDetailScreen extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback? onFindShelterTap;

  const AlertDetailScreen({
    super.key,
    required this.alert,
    this.onFindShelterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Alert Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Alert',
            onPressed: () => AppHelpers.shareAlert(context, alert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prominent Emergency Banner
            Container(
              color: alert.severityBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: alert.severityColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(alert.typeIcon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              alert.typeDisplayName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: alert.severityColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const Spacer(),
                            StatusBadge.fromSeverity(alert.severity, isLarge: true),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Issued: ${alert.timeAgo}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    alert.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Location & Radius Meta Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _metaRow(
                          icon: Icons.location_on_rounded,
                          label: 'Affected Zone',
                          value: alert.location,
                        ),
                        const Divider(height: 18),
                        _metaRow(
                          icon: Icons.radar_rounded,
                          label: 'Alert Radius',
                          value: '${alert.affectedRadiusKm} km around epicenter',
                        ),
                        const Divider(height: 18),
                        _metaRow(
                          icon: Icons.verified_user_rounded,
                          label: 'Authorized Source',
                          value: alert.source,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Detailed Description
                  const Text(
                    'Situation Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Safety Instructions
                  const Text(
                    'Mandatory Safety Protocol',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(alert.safetyInstructions.length, (index) {
                    final instruction = alert.safetyInstructions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: alert.severityColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: alert.severityColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              instruction,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Action Buttons
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emergencyRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      AppHelpers.makePhoneCall(
                          context, AppConstants.nationalDisasterHelpline);
                    },
                    icon: const Icon(Icons.call_rounded, size: 20),
                    label: const Text(
                      'Call National Helpline (112)',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (onFindShelterTap != null) {
                        Navigator.of(context).pop();
                        onFindShelterTap!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.holiday_village_rounded, size: 20),
                    label: const Text(
                      'Find Nearby Evacuation Shelter',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => AppHelpers.shareAlert(context, alert),
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('Broadcast Alert to Contacts'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.infoBlue),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
