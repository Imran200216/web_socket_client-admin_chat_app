import 'package:socket_io_admin_client/features/chat/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  // Send Chat To User
  Future<ChatEntity> sendChatToUser(
    String messageSender,
    String chatMessage,
    DateTime timestamp,
  );

  // Read Chats
  Future<List<ChatEntity>> readAllChats(String userUid);
}
