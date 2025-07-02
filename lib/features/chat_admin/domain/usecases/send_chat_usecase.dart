import 'package:socket_io_admin_client/features/chat_admin/domain/entities/chat_entity.dart';
import 'package:socket_io_admin_client/features/chat_admin/domain/repository/chat_repository.dart';

class SendChatUseCase {
  final ChatRepository chatRepository;

  SendChatUseCase({required this.chatRepository});

  Future<ChatEntity> call(
    String messageSender,
    String chatMessage,
    DateTime timestamp,
  ) async {
    return await chatRepository.sendChatToUser(
      messageSender,
      chatMessage,
      timestamp,
    );
  }
}
