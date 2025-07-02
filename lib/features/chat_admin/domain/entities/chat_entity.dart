class ChatEntity {
  final String messageSender;
  final String chatMessage;
  final DateTime timestamp;

  ChatEntity({
    required this.messageSender,
    required this.chatMessage,
    required this.timestamp,
  });
}
