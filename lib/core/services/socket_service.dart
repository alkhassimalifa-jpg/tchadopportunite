import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../config/app_config.dart';
import 'storage_service.dart';
import '../../features/messaging/data/message_entity.dart';

class SocketService {
  IO.Socket? _socket;

  Future<void> connect() async {
    final token = await StorageService.getAccessToken();
    if (token == null) return;

    _socket = IO.io(
      AppConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }

  void joinConversation(String otherUserId) {
    _socket?.emit('join_conversation', otherUserId);
  }

  void sendMessage(String receiverId, String content) {
    _socket?.emit('send_message', {
      'receiverId': receiverId,
      'content': content,
    });
  }

  void onNewMessage(Function(MessageEntity) callback) {
    _socket?.on('new_message', (data) {
      callback(MessageEntity.fromJson(data));
    });
  }

  void sendTyping(String receiverId, bool isTyping) {
    _socket?.emit('typing', {
      'receiverId': receiverId,
      'isTyping': isTyping,
    });
  }

  void onUserTyping(Function(String userId, bool isTyping) callback) {
    _socket?.on('user_typing', (data) {
      callback(data['userId'], data['isTyping']);
    });
  }

  void markAsRead(String senderId) {
    _socket?.emit('mark_read', {'senderId': senderId});
  }

  void onUserOnline(Function(String userId) callback) {
    _socket?.on('user_online', (data) => callback(data['userId']));
  }

  void onUserOffline(Function(String userId) callback) {
    _socket?.on('user_offline', (data) => callback(data['userId']));
  }

  bool get isConnected => _socket?.connected ?? false;
}

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(() => service.disconnect());
  return service;
});
