import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/features/chat/data/models/chat_models.dart';
import 'package:socket_io_admin_client/features/chat/domain/entities/chat_entity.dart';

class FirestoreChatDataSource {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Send Chat
  Future<ChatEntity> sendChatToUser(
    String messageSender,
    String chatMessage,
    DateTime timestamp,
  ) async {
    final chatModel = ChatModel(
      messageSender: messageSender,
      chatMessage: chatMessage,
      timestamp: timestamp,
    );

    final docRef = firebaseFirestore
        .collection(AppDBConstants.chatCollection)
        .doc();

    await docRef.set(chatModel.toJson());

    return chatModel;
  }

  // Read Chat
  Future<List<ChatEntity>> readChats(String userUid) async {
    final querySnapshot = await firebaseFirestore
        .collection(AppDBConstants.chatCollection)
        .where('messageSender', isEqualTo: userUid)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ChatModel.fromJson(doc.data()))
        .toList();
  }
}
