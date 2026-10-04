import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/alert.dart';
import '../../providers/alert_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/custom_filter_chip.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/search_field.dart';
import 'alert_detail_screen.dart';
import 'report_hazard_screen.dart';

class AlertFeedScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const AlertFeedScreen({super.key, this.onNavigateTab});

  @override
  State<AlertFeedScreen> createState() => _AlertFeedScreenState();
}

class _AlertFeedScreenState extends State<AlertFeedScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSimulatedAlert() {
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
                'SIMULATED: ${alert.title}',
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
                  onFindShelterTap: () => widget.onNavigateTab?.call(2),
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
    final alertProvider = Provider.of<AlertProvider>(context);
    final alerts = alertProvider.filteredAlerts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Alert Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt_rounded, color: AppColors.emergencyRed),
            tooltip: 'Simulate Live Alert',
            onPressed: _triggerSimulatedAlert,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.emergencyRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Report Hazard'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReportHazardScreen()),
          );
        },
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchField(
              hintText: 'Search alerts by disaster type, location...',
              controller: _searchController,
              onChanged: (val) => alertProvider.setSearchQuery(val),
            ),
          ),
          // Severity Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                CustomFilterChip(
                  label: 'All (${alertProvider.allAlerts.length})',
                  isSelected: alertProvider.selectedSeverity == null,
                  onSelected: (_) => alertProvider.setSeverityFilter(null),
                  activeColor: AppColors.infoBlue,
                ),
                CustomFilterChip(
                  label: 'Critical',
                  isSelected: alertProvider.selectedSeverity == AlertSeverity.critical,
                  onSelected: (_) =>
                      alertProvider.setSeverityFilter(AlertSeverity.critical),
                  activeColor: AppColors.emergencyRed,
                ),
                CustomFilterChip(
                  label: 'High',
                  isSelected: alertProvider.selectedSeverity == AlertSeverity.high,
                  onSelected: (_) =>
                      alertProvider.setSeverityFilter(AlertSeverity.high),
                  activeColor: AppColors.warningOrange,
                ),
                CustomFilterChip(
                  label: 'Medium',
                  isSelected: alertProvider.selectedSeverity == AlertSeverity.medium,
                  onSelected: (_) =>
                      alertProvider.setSeverityFilter(AlertSeverity.medium),
                  activeColor: const Color(0xFFC79200),
                ),
                CustomFilterChip(
                  label: 'Low Advisory',
                  isSelected: alertProvider.selectedSeverity == AlertSeverity.low,
                  onSelected: (_) =>
                      alertProvider.setSeverityFilter(AlertSeverity.low),
                  activeColor: AppColors.safeGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Active Only Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${alerts.length} alerts',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                InkWell(
                  onTap: () =>
                      alertProvider.toggleOnlyActive(!alertProvider.onlyActive),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Row(
                    children: [
                      Checkbox(
                        value: alertProvider.onlyActive,
                        activeColor: AppColors.emergencyRed,
                        visualDensity: VisualDensity.compact,
                        onChanged: (val) =>
                            alertProvider.toggleOnlyActive(val ?? false),
                      ),
                      const Text(
                        'Active Emergencies Only',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 12),
          // List of Alerts
          Expanded(
            child: alerts.isEmpty
                ? EmptyStateWidget.noAlerts(
                    onReset: () {
                      _searchController.clear();
                      alertProvider.clearFilters();
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AlertCard(
                          alert: alert,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AlertDetailScreen(
                                  alert: alert,
                                  onFindShelterTap: () =>
                                      widget.onNavigateTab?.call(2),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
