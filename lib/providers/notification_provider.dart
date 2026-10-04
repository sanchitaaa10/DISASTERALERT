import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> get notifications => _service.getNotifications();

  int get unreadCount => _service.unreadCount;

  void markAsRead(String id) {
    _service.markAsRead(id);
    notifyListeners();
  }

  void markAllAsRead() {
    _service.markAllAsRead();
    notifyListeners();
  }

  void clearAll() {
    _service.clearAll();
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _service.addNotification(notification);
    notifyListeners();
  }
}
