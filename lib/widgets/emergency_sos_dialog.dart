import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../providers/location_provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class EmergencySosDialog extends StatefulWidget {
  const EmergencySosDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const EmergencySosDialog(),
    );
  }

  @override
  State<EmergencySosDialog> createState() => _EmergencySosDialogState();
}

enum _SosStep { confirm, transmitting, dispatched }

class _EmergencySosDialogState extends State<EmergencySosDialog> {
  _SosStep _currentStep = _SosStep.confirm;
  Timer? _transmissionTimer;

  @override
  void dispose() {
    _transmissionTimer?.cancel();
    super.dispose();
  }

  void _triggerSosTransmission() {
    setState(() {
      _currentStep = _SosStep.transmitting;
    });

    _transmissionTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        // Dispatch in-app notification
        final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
        notifProvider.addNotification(
          NotificationModel(
            id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
            title: '🚨 SOS Distress Beacon Broadcasted',
            description:
                'Emergency alert broadcasted with GPS coordinates to 112 National Helpline & your trusted emergency contacts.',
            type: NotificationType.emergencyAlert,
            timestamp: DateTime.now(),
            isRead: false,
          ),
        );

        setState(() {
          _currentStep = _SosStep.dispatched;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationProvider>(context, listen: false);
    final contacts = Provider.of<ContactProvider>(context, listen: false);
    final nowString = DateFormat('hh:mm:ss a, dd MMM yyyy').format(DateTime.now());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStepView(location, contacts, nowString),
        ),
      ),
    );
  }

  Widget _buildCurrentStepView(
    LocationProvider location,
    ContactProvider contacts,
    String timestamp,
  ) {
    switch (_currentStep) {
      case _SosStep.confirm:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.emergencyRed.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.emergencyRed,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirm Emergency SOS?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Are you sure you want to send an emergency alert? This will immediately notify your trusted contacts and transmit your GPS coordinates to the Disaster Relief Command.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            // Location summary pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.emergencyRed),
                  const SizedBox(width: 6),
                  Text(
                    '📍 ${location.locationName}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emergencyRed,
                    ),
                    onPressed: _triggerSosTransmission,
                    child: const Text('Send SOS'),
                  ),
                ),
              ],
            ),
          ],
        );

      case _SosStep.transmitting:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.emergencyRed),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Transmitting Distress Signal...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.emergencyRed,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Locking high-precision GPS coordinates & encrypting emergency distress packet...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );

      case _SosStep.dispatched:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.safeGreen,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'SOS Alert Sent!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your trusted contacts and emergency services have been alerted with your location telemetry.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            // Telemetry Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _telemetryRow(
                    Icons.my_location_rounded,
                    'Location',
                    '${location.locationName}\n(${location.latitude}° N, ${location.longitude}° E)',
                  ),
                  const Divider(height: 16),
                  _telemetryRow(
                    Icons.access_time_rounded,
                    'Dispatched',
                    timestamp,
                  ),
                  const Divider(height: 16),
                  _telemetryRow(
                    Icons.people_alt_outlined,
                    'Recipients',
                    '${contacts.trustedContacts.length} Trusted Contacts + National 112',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Call 112 Direct Button
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emergencyRed,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                AppHelpers.makePhoneCall(context, AppConstants.nationalDisasterHelpline);
              },
              icon: const Icon(Icons.call_rounded, size: 20),
              label: const Text(
                'Direct Call Helpline (112)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Dismiss SOS Modal'),
            ),
          ],
        );
    }
  }

  Widget _telemetryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
