import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/contact_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/shelter_provider.dart';
import '../../providers/survival_kit_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/emergency_button.dart';
import '../../widgets/emergency_sos_dialog.dart';
import '../../widgets/environmental_telemetry_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/safety_checkin_card.dart';
import '../../widgets/safety_tip_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shelter_card.dart';
import '../alerts/alert_detail_screen.dart';
import '../alerts/report_hazard_screen.dart';
import '../contacts/emergency_contacts_screen.dart';
import '../notifications/notification_screen.dart';
import '../shelters/shelter_detail_screen.dart';
import '../survival/survival_kit_screen.dart';
import '../tools/rescue_beacon_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({super.key, required this.onNavigateTab});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _triggerSimulateAlert(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
    final alert = alertProvider.triggerSimulatedAlert(notifProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: alert.severityColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'LIVE THREAT DETECTED: ${alert.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AlertDetailScreen(
                  alert: alert,
                  onFindShelterTap: () => onNavigateTab(2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);
    final shelterProvider = Provider.of<ShelterProvider>(context);
    final notifProvider = Provider.of<NotificationProvider>(context);
    final location = Provider.of<LocationProvider>(context);
    final contacts = Provider.of<ContactProvider>(context);
    final survivalKit = Provider.of<SurvivalKitProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final latestAlert = alertProvider.latestAlert;
    final nearbyShelters = shelterProvider.allShelters.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Emergency Grid Active',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColorsDark.safeGreen : AppColors.safeGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Tactical Dark/Light Mode Toggle
          IconButton(
            icon: Icon(
              theme.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
              color: theme.isDarkMode ? AppColorsDark.cautionYellow : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
            ),
            tooltip: theme.isDarkMode ? 'Switch to Light Mode' : 'Switch to Tactical Night Mode',
            onPressed: () => theme.toggleDarkMode(),
          ),
          // Simulate Alert Button (for B.Tech Demo)
          IconButton(
            icon: Icon(Icons.bolt_rounded, color: isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed),
            tooltip: 'Simulate Live Disaster Alert',
            onPressed: () => _triggerSimulateAlert(context),
          ),
          // Notification Bell with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationScreen()),
                  );
                },
              ),
              if (notifProvider.unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.emergencyRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${notifProvider.unreadCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          location.refreshLocation();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Greeting Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Stay safe, ${theme.userName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.emergencyRed),
                        const SizedBox(width: 4),
                        Text(
                          location.locationName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Emergency Status Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: alertProvider.overallThreatColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: alertProvider.overallThreatColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: alertProvider.overallThreatColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: alertProvider.overallThreatColor.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT REGIONAL THREAT STATUS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alertProvider.overallThreatLevel,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: alertProvider.overallThreatColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${alertProvider.activeAlertsCount} Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: alertProvider.overallThreatColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Safety Status Check-In Card
              const SafetyCheckinCard(),
              const SizedBox(height: 16),

              // Large SOS Button
              EmergencyButton(
                onPressed: () => EmergencySosDialog.show(context),
              ),
              const SizedBox(height: 18),

              // Live Environmental Telemetry Widget
              const EnvironmentalTelemetryCard(),
              const SizedBox(height: 22),

              // Quick Actions Grid (6 Tactical Tools)
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.28,
                children: [
                  QuickActionCard(
                    icon: Icons.contact_phone_rounded,
                    title: 'Helplines',
                    subtitle: '${contacts.trustedContacts.length} Trusted • 112',
                    color: isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed,
                    badgeText: '112',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyContactsScreen(),
                        ),
                      );
                    },
                  ),
                  QuickActionCard(
                    icon: Icons.health_and_safety_rounded,
                    title: 'First Aid',
                    subtitle: '10 Offline Guides',
                    color: isDark ? AppColorsDark.safeGreen : AppColors.safeGreen,
                    onTap: () => onNavigateTab(3),
                  ),
                  QuickActionCard(
                    icon: Icons.holiday_village_rounded,
                    title: 'Find Shelter',
                    subtitle: '${shelterProvider.availableSheltersCount} Available',
                    color: isDark ? AppColorsDark.infoBlue : AppColors.infoBlue,
                    onTap: () => onNavigateTab(2),
                  ),
                  QuickActionCard(
                    icon: Icons.crisis_alert_rounded,
                    title: 'Alert Feed',
                    subtitle: '${alertProvider.allAlerts.length} Total Warnings',
                    color: isDark ? AppColorsDark.warningOrange : AppColors.warningOrange,
                    badgeText: alertProvider.activeAlertsCount > 0
                        ? '${alertProvider.activeAlertsCount}'
                        : null,
                    onTap: () => onNavigateTab(1),
                  ),
                  QuickActionCard(
                    icon: Icons.backpack_rounded,
                    title: 'Go-Bag Kit',
                    subtitle: '${survivalKit.packedCount}/${survivalKit.totalCount} Packed (${survivalKit.readinessScore}%)',
                    color: isDark ? AppColorsDark.safeGreen : AppColors.safeGreen,
                    badgeText: '${survivalKit.readinessScore}%',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SurvivalKitScreen(),
                        ),
                      );
                    },
                  ),
                  QuickActionCard(
                    icon: Icons.flash_on_rounded,
                    title: 'Rescue Tools',
                    subtitle: 'Strobe & Siren HUD',
                    color: isDark ? AppColorsDark.cautionYellow : const Color(0xFFD97706),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RescueBeaconScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Community Hazard Report Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: (isDark ? AppColorsDark.warningOrange : AppColors.warningOrange).withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColorsDark.warningOrange : AppColors.warningOrange).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_location_alt_rounded,
                        color: isDark ? AppColorsDark.warningOrange : AppColors.warningOrange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spotted a Local Hazard?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Report waterlogging, road blocks, or power issues in Kharghar',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark ? AppColorsDark.warningOrange : AppColors.warningOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(60, 36),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReportHazardScreen()),
                        );
                      },
                      child: const Text('Report', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Active Alert Section
              if (latestAlert != null) ...[
                SectionHeader(
                  title: 'Latest Active Alert',
                  actionLabel: 'View All',
                  onActionTap: () => onNavigateTab(1),
                ),
                const SizedBox(height: 8),
                AlertCard(
                  alert: latestAlert,
                  isFeatured: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AlertDetailScreen(
                          alert: latestAlert,
                          onFindShelterTap: () => onNavigateTab(2),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
              ],

              // Nearby Shelters Section
              SectionHeader(
                title: 'Nearby Evacuation Shelters',
                subtitle: 'Nearest relief facilities to Kharghar base',
                actionLabel: 'View Radar Map',
                onActionTap: () => onNavigateTab(2),
              ),
              const SizedBox(height: 8),
              ...nearbyShelters.map((shelter) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ShelterCard(
                    shelter: shelter,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ShelterDetailScreen(shelter: shelter),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 14),

              // Rotating Safety Tips Card
              const SectionHeader(title: 'Safety Guidelines'),
              const SizedBox(height: 8),
              const SafetyTipCard(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
