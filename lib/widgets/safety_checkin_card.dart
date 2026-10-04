import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/notification_model.dart';
import '../providers/contact_provider.dart';
import '../providers/location_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class SafetyCheckinCard extends StatelessWidget {
  const SafetyCheckinCard({super.key});

  void _showSafetyBroadcastModal(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);
    final contacts = Provider.of<ContactProvider>(context, listen: false);
    final notifProvider = Provider.of<NotificationProvider>(context, listen: false);

    final now = DateTime.now();
    final timeStr = DateFormat('hh:mm a, dd MMM yyyy').format(now);
    final message = '''🟢 [DISASTERALERT] I AM SAFE
I have marked myself safe and uninjured during the current advisory.
👤 Name: ${theme.userName}
📍 Location: ${location.locationName} (${location.latitude.toStringAsFixed(4)}° N, ${location.longitude.toStringAsFixed(4)}° E)
🕒 Time: $timeStr
⚡ Broadcasted via DisasterAlert Emergency Grid''';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final sheetBg = isDark ? AppColorsDark.surface : AppColors.surface;
        final borderCol = isDark ? AppColorsDark.border : AppColors.border;
        final textColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
        final subtextColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            border: Border.all(color: borderCol),
          ),
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColorsDark.border : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.safeGreen.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.safeGreen, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Broadcast "I Am Safe" Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Sends GPS telemetry to trusted contacts & WhatsApp',
                          style: TextStyle(fontSize: 12, color: subtextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Message Preview Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColors.safeGreen.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                child: SelectableText(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'monospace',
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Action Buttons
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.safeGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.send_rounded, size: 20),
                label: Text(
                  contacts.trustedContacts.isNotEmpty
                      ? 'Send SMS to ${contacts.trustedContacts.length} Trusted Contacts'
                      : 'Send Safety SMS (Dialer/SMS)',
                ),
                onPressed: () async {
                  await theme.recordSafeCheckin();
                  notifProvider.addNotification(
                    NotificationModel(
                      id: 'safe_${DateTime.now().millisecondsSinceEpoch}',
                      title: '🟢 "I Am Safe" Status Broadcasted',
                      description: 'Safety check-in sent from ${location.locationName} at $timeStr.',
                      type: NotificationType.safetyReminder,
                      timestamp: DateTime.now(),
                      isRead: false,
                    ),
                  );

                  if (context.mounted) {
                    Navigator.of(ctx).pop();
                    if (contacts.trustedContacts.isNotEmpty) {
                      for (final contact in contacts.trustedContacts) {
                        AppHelpers.sendEmergencySms(context, contact.phone, message);
                      }
                    } else {
                      AppHelpers.sendEmergencySms(context, '112', message);
                    }
                  }
                },
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                      label: const Text('WhatsApp'),
                      onPressed: () async {
                        await theme.recordSafeCheckin();
                        if (context.mounted) {
                          Navigator.of(ctx).pop();
                        }
                        final waUri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(message)}');
                        try {
                          if (await canLaunchUrl(waUri)) {
                            await launchUrl(waUri);
                          } else {
                            final webWa = Uri.parse('https://api.whatsapp.com/send?text=${Uri.encodeComponent(message)}');
                            await launchUrl(webWa, mode: LaunchMode.externalApplication);
                          }
                        } catch (_) {
                          if (context.mounted) {
                            Clipboard.setData(ClipboardData(text: message));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message copied to clipboard for sharing!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copy Text'),
                      onPressed: () async {
                        await theme.recordSafeCheckin();
                        await Clipboard.setData(ClipboardData(text: message));
                        if (context.mounted) {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.safeGreen,
                              content: Text('Safety broadcast message copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final location = Provider.of<LocationProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasCheckedIn = theme.lastSafeCheckin != null;
    final lastTimeText = hasCheckedIn ? _formatTimeAgo(theme.lastSafeCheckin!) : null;

    final bgColor = isDark
        ? (hasCheckedIn ? AppColorsDark.safeGreenSurface : AppColorsDark.surface)
        : (hasCheckedIn ? AppColors.safeGreenSurface : AppColors.surface);
    final borderColor = isDark
        ? (hasCheckedIn ? AppColorsDark.safeGreen.withOpacity(0.5) : AppColorsDark.border)
        : (hasCheckedIn ? AppColors.safeGreen.withOpacity(0.5) : AppColors.border);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor, width: 1.3),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.safeGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasCheckedIn ? Icons.verified_user_rounded : Icons.health_and_safety_rounded,
              color: AppColors.safeGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      hasCheckedIn ? 'MARKED AS SAFE' : 'SAFETY CHECK-IN',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.safeGreen,
                      ),
                    ),
                    if (hasCheckedIn) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '• $lastTimeText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  hasCheckedIn
                      ? '${theme.userName} safe at ${location.locationName}'
                      : 'Notify family & trusted circle that you are uninjured',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.safeGreen.withOpacity(0.16),
              foregroundColor: AppColors.safeGreen,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(60, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            onPressed: () => _showSafetyBroadcastModal(context),
            child: Text(
              hasCheckedIn ? 'Update' : 'I Am Safe',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
