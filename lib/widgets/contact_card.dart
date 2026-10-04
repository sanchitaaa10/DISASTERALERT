import 'package:flutter/material.dart';
import '../models/emergency_contact.dart';
import '../models/trusted_contact.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class EmergencyContactCard extends StatelessWidget {
  final EmergencyContact contact;

  const EmergencyContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: contact.categoryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(contact.icon, color: contact.categoryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Helpline: ${contact.phone}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: contact.categoryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contact.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () {
                    AppHelpers.sendEmergencySms(
                      context,
                      contact.phone,
                      'EMERGENCY: Immediate assistance requested at Kharghar, Navi Mumbai.',
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('MESSAGE', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: contact.categoryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () {
                    AppHelpers.makePhoneCall(context, contact.phone);
                  },
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: const Text('CALL', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrustedContactCard extends StatelessWidget {
  final TrustedContact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TrustedContactCard({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: contact.isPrimary ? AppColors.emergencyRed : AppColors.border,
          width: contact.isPrimary ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: contact.isPrimary
                      ? AppColors.emergencyRed.withOpacity(0.12)
                      : AppColors.infoBlue.withOpacity(0.12),
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : 'C',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: contact.isPrimary
                          ? AppColors.emergencyRed
                          : AppColors.infoBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (contact.isPrimary)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.emergencyRedSurface,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: AppColors.emergencyRed.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'PRIMARY SOS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.emergencyRed,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${contact.relationship} • ${contact.phone}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, size: 20),
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit Contact'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 18, color: AppColors.emergencyRed),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: AppColors.emergencyRed),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (contact.notes != null && contact.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                contact.notes!,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () {
                    AppHelpers.sendEmergencySms(
                      context,
                      contact.phone,
                      'EMERGENCY ALERT: I am using DisasterAlert. My GPS location is Kharghar, Navi Mumbai (19.0473° N, 73.0699° E). Please reach out immediately.',
                    );
                  },
                  icon: const Icon(Icons.emergency_outlined,
                      size: 16, color: AppColors.emergencyRed),
                  label: const Text('SEND SOS SMS',
                      style: TextStyle(fontSize: 11, color: AppColors.emergencyRed)),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.safeGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () {
                    AppHelpers.makePhoneCall(context, contact.phone);
                  },
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: const Text('CALL', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
