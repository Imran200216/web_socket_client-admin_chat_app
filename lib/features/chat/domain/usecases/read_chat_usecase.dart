import 'package:socket_io_admin_client/features/chat/domain/entities/chat_entity.dart';
import 'package:socket_io_admin_client/features/chat/domain/repository/chat_repository.dart';

class ReadChatUseCase {
  final ChatRepository chatRepository;

  ReadChatUseCase({required this.chatRepository});

  Future<List<ChatEntity>> call(String userUid) async {
    return await chatRepository.readAllChats(userUid);
  }
}
