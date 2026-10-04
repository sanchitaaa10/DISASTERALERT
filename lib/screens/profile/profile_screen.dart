import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/contact_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';
import '../alerts/report_hazard_screen.dart';
import '../contacts/trusted_contacts_screen.dart';
import '../survival/survival_kit_screen.dart';
import '../tools/rescue_beacon_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, ThemeProvider theme) {
    final nameCtrl = TextEditingController(text: theme.userName);
    final phoneCtrl = TextEditingController(text: theme.userPhone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Edit Emergency Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Primary Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              theme.updateProfile(
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showInfoModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final contactProvider = Provider.of<ContactProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: _sectionDecoration(isDark),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.emergencyRed.withOpacity(0.12),
                    child: Text(
                      theme.userName.isNotEmpty ? theme.userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.emergencyRed,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          theme.userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          theme.userPhone,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 13, color: isDark ? AppColorsDark.infoBlue : AppColors.infoBlue),
                            const SizedBox(width: 4),
                            Text(
                              '📍 Kharghar, Navi Mumbai',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColorsDark.infoBlue : AppColors.infoBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () => _showEditProfileDialog(context, theme),
                    tooltip: 'Edit Profile',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tactical Display Theme Mode
            _sectionLabel('TACTICAL DISPLAY THEME'),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: _sectionDecoration(isDark),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Theme Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'High-contrast tactical dark HUD optimizes readability during nighttime power outages',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_rounded, size: 16),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_rounded, size: 16),
                          label: Text('Tactical Dark'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_rounded, size: 16),
                          label: Text('System'),
                        ),
                      ],
                      selected: {theme.themeMode},
                      onSelectionChanged: (set) => theme.setThemeMode(set.first),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Crisis Utilities & Tools
            _sectionLabel('CRISIS UTILITIES & TOOLS'),
            Container(
              decoration: _sectionDecoration(isDark),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.safeGreen.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.backpack_rounded, color: AppColors.safeGreen, size: 20),
                    ),
                    title: const Text('Evacuation Go-Bag Kit',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                      'Interactive checklist for water, rations, and survival gear',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SurvivalKitScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColorsDark.cautionYellow : const Color(0xFFD97706)).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.flash_on_rounded,
                        color: isDark ? AppColorsDark.cautionYellow : const Color(0xFFD97706),
                        size: 20,
                      ),
                    ),
                    title: const Text('Tactical Rescue Tools',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                      'Optical SOS screen strobe, audible distress siren, and compass HUD',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RescueBeaconScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warningOrange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_location_alt_rounded, color: AppColors.warningOrange, size: 20),
                    ),
                    title: const Text('Report Hazard / Incident',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                      'Crowdsource waterlogged roads, fallen trees, or fires',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ReportHazardScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Emergency Preferences
            _sectionLabel('EMERGENCY PREFERENCES'),
            Container(
              decoration: _sectionDecoration(isDark),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Emergency Audio Alarm',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Play high-decibel alert siren on critical warnings',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    value: theme.soundEnabled,
                    activeColor: AppColors.emergencyRed,
                    onChanged: (val) => theme.toggleSound(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Haptic SOS Vibration',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Vibrate device during urgent earthquake & flood alerts',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    value: theme.vibrationEnabled,
                    activeColor: AppColors.emergencyRed,
                    onChanged: (val) => theme.toggleVibration(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Real-time Geo-Tracking',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Include GPS coordinate telemetry in SOS broadcasts',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    value: theme.locationAccessEnabled,
                    activeColor: AppColors.safeGreen,
                    onChanged: (val) => theme.toggleLocationAccess(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Push Disaster Advisories',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Receive NDMA & IMD weather alerts in background',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    value: theme.notificationsEnabled,
                    activeColor: AppColors.infoBlue,
                    onChanged: (val) => theme.toggleNotifications(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Emergency Network
            _sectionLabel('SAFETY NETWORK'),
            Container(
              decoration: _sectionDecoration(isDark),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.emergencyRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.people_alt_rounded,
                      color: AppColors.emergencyRed, size: 20),
                ),
                title: const Text('Manage Trusted Contacts',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${contactProvider.trustedContacts.length} contacts linked to SOS distress beacon',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TrustedContactsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // About Project Metadata
            _sectionLabel('ABOUT DISASTERALERT'),
            Container(
              decoration: _sectionDecoration(isDark),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Project Specification',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                      'Application 24 • Problem Statement 74 • B.Tech Flutter',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: const Icon(Icons.info_outline_rounded, size: 18),
                    onTap: () {
                      _showInfoModal(
                        context,
                        'B.Tech Project 24 (Statement 74)',
                        'Title: DISASTERALERT\n\nObjective: A cross-platform Flutter emergency and disaster-assistance platform designed to provide real-time alerts, fast emergency contact dispatch, shelter availability tracking, and offline-accessible first-aid procedures for regional crisis mitigation in Kharghar & Navi Mumbai.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Privacy & Location Policy',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      _showInfoModal(
                        context,
                        'Privacy & Emergency Data Policy',
                        'DisasterAlert processes GPS coordinate telemetry solely during emergency SOS dispatches to authorized responders and trusted contacts. Personal data remains cached on the local device via SharedPreferences and is never commercialized.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Terms of Emergency Assistance',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      _showInfoModal(
                        context,
                        'Terms of Emergency Service',
                        'DisasterAlert is an emergency assistance and educational tool. During civil crisis, users should always comply with on-ground directives from local police, NDRF, and municipal disaster management squads.',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  BoxDecoration _sectionDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColorsDark.surface : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
    );
  }
}
