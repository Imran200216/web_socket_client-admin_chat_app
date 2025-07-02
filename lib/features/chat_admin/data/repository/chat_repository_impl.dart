import 'package:socket_io_admin_client/features/chat_admin/data/datasources/Firestore_chat_datasource.dart';
import 'package:socket_io_admin_client/features/chat_admin/domain/entities/chat_entity.dart';
import 'package:socket_io_admin_client/features/chat_admin/domain/repository/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final FirestoreChatDataSource firestoreChatDataSource;

  ChatRepositoryImpl({required this.firestoreChatDataSource});

  @override
  Future<List<ChatEntity>> readAllChats(String userUid) async {
    return await firestoreChatDataSource.readChats(userUid);
  }

  @override
  Future<ChatEntity> sendChatToUser(
    String messageSender,
    String chatMessage,
    DateTime timestamp,
  ) async {
    return await firestoreChatDataSource.sendChatToUser(
      messageSender,
      chatMessage,
      timestamp,
    );
  }
}
