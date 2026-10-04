import '../models/notification_model.dart';
import '../data/mock_notifications.dart';

class NotificationService {
  List<NotificationModel> _notifications = List.from(kMockNotifications);

  List<NotificationModel> getNotifications() {
    return List.unmodifiable(_notifications);
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
  }

  void clearAll() {
    _notifications.clear();
  }

  void addNotification(NotificationModel notification) {
    _notifications = [notification, ..._notifications];
  }
}
