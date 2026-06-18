import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, senderId, receiverId, content, createdAt];
}

class ConversationEntity extends Equatable {
  final String partnerId;
  final String partnerName;
  final String? partnerPhoto;
  final String lastMessage;
  final DateTime lastMessageDate;
  final int unreadCount;

  const ConversationEntity({
    required this.partnerId,
    required this.partnerName,
    this.partnerPhoto,
    required this.lastMessage,
    required this.lastMessageDate,
    this.unreadCount = 0,
  });

  factory ConversationEntity.fromJson(Map<String, dynamic> json) {
    final partner = json['partner'];
    final lastMsg = json['lastMessage'];
    return ConversationEntity(
      partnerId: partner['id'] ?? '',
      partnerName: '${partner['firstName']} ${partner['lastName']}',
      partnerPhoto: partner['photoUrl'],
      lastMessage: lastMsg['content'] ?? '',
      lastMessageDate: DateTime.parse(lastMsg['createdAt']),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [partnerId, lastMessage, unreadCount];
}

