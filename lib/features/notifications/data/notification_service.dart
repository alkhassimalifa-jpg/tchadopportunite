import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';

// ─── Entity ───────────────────────────────────────────────────

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  IconData get icon {
    switch (type) {
      case 'NEW_APPLICATION': return Icons.send_rounded;
      case 'APPLICATION_STATUS': return Icons.work_rounded;
      case 'NEW_MESSAGE': return Icons.chat_bubble_rounded;
      case 'NEW_REVIEW': return Icons.star_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  @override
  List<Object?> get props => [id, isRead, type];
}

// ─── Service ──────────────────────────────────────────────────

class NotificationService {
  final ApiClient _api;

  NotificationService(this._api);

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _api.get('/notifications');
    return {
      'notifications': (response.data['data']['notifications'] as List)
          .map((n) => NotificationEntity.fromJson(n))
          .toList(),
      'unreadCount': response.data['data']['unreadCount'] as int,
    };
  }

  Future<void> markAsRead(String id) async {
    await _api.patch('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _api.patch('/notifications/read-all');
  }

  Future<void> deleteNotification(String id) async {
    await _api.delete('/notifications/$id');
  }
}

// ─── Providers ────────────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.read(apiClientProvider));
});

final notificationsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  return ref.read(notificationServiceProvider).getNotifications();
});