import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/features/chat/domain/entities/chat_entity.dart';
import 'package:socket_io_admin_client/features/chat/domain/usecases/read_chat_usecase.dart';
import 'package:socket_io_admin_client/features/chat/domain/usecases/send_chat_usecase.dart';

class ChatProvider extends ChangeNotifier {
  final SendChatUseCase sendChatUseCase;
  final ReadChatUseCase readChatUseCase;

  ChatProvider({required this.sendChatUseCase, required this.readChatUseCase});

  bool _isLoading = false;
  String? _error;

  List<ChatEntity> _chats = [];

  List<ChatEntity> get chats => _chats;

  bool get isLoading => _isLoading;

  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  // Send a new chat message
  Future<void> sendChat({
    required String senderId,
    required String message,
    required DateTime timestamp,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await sendChatUseCase(senderId, message, timestamp);
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  // Read all chat messages for a user
  Future<void> readChats(String userUid) async {
    _setLoading(true);
    _setError(null);

    try {
      final chatList = await readChatUseCase(userUid);
      _chats = chatList;
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  void addIncomingChat(String message, String senderId) {
    final chat = ChatEntity(
      chatMessage: message,
      messageSender: senderId,
      timestamp: DateTime.now(),
    );
    _chats.add(chat);
    notifyListeners();
  }

  void clearChats() {
    _chats.clear();
    notifyListeners();
  }
}
