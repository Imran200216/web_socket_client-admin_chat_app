import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:socket_io_admin_client/features/chat_admin/data/models/chat_models.dart';

class FirestoreChatDataSource {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Send Chat
  Future<ChatModel> sendChatToUser(
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
  Future<List<ChatModel>> readChats(String userUid) async {
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
