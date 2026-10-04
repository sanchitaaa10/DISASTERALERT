import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/notification_tile.dart';
import '../alerts/alert_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final notifications = notifProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications (${notifProvider.unreadCount} Unread)',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'read_all') notifProvider.markAllAsRead();
                if (val == 'clear_all') notifProvider.clearAll();
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: 'read_all',
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_read_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Mark All as Read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all_rounded,
                          size: 18, color: AppColors.emergencyRed),
                      SizedBox(width: 8),
                      Text('Clear All',
                          style: TextStyle(color: AppColors.emergencyRed)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              description: 'You are all caught up with latest disaster warnings and shelter notices.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NotificationTile(
                    notification: notif,
                    onTap: () {
                      notifProvider.markAsRead(notif.id);
                      if (notif.relatedEntityId != null) {
                        final alert = alertProvider.getAlertById(notif.relatedEntityId!);
                        if (alert != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlertDetailScreen(alert: alert),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
