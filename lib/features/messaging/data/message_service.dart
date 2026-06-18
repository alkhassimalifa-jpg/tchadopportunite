import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import 'message_entity.dart';

class MessageService {
  final ApiClient _api;

  MessageService(this._api);

  Future<List<ConversationEntity>> getConversations() async {
    final response = await _api.get('/messages/conversations');
    return (response.data['data']['conversations'] as List)
        .map((c) => ConversationEntity.fromJson(c))
        .toList();
  }

  Future<List<MessageEntity>> getMessages(String otherUserId) async {
    final response = await _api.get('/messages/$otherUserId');
    return (response.data['data']['messages'] as List)
        .map((m) => MessageEntity.fromJson(m))
        .toList();
  }
}

final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService(ref.read(apiClientProvider));
});

final conversationsProvider =
    FutureProvider.autoDispose<List<ConversationEntity>>((ref) async {
  final service = ref.read(messageServiceProvider);
  return service.getConversations();
});
