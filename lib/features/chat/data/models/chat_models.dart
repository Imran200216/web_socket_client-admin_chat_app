import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_admin_client/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.messageSender,
    required super.chatMessage,
    required super.timestamp,
  });

  // From JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      messageSender: json['messageSender'] as String,
      chatMessage: json['chatMessage'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'messageSender': messageSender,
      'chatMessage': chatMessage,
      'timestamp': timestamp,
    };
  }
}
