import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/commons/widgets/KAppBar.dart';
import 'package:socket_io_admin_client/commons/widgets/KAppDrawer.dart';
import 'package:socket_io_admin_client/commons/widgets/KChatBubble.dart';
import 'package:socket_io_admin_client/commons/widgets/KHorizontalSpacer.dart';
import 'package:socket_io_admin_client/commons/widgets/KTextFormField.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/core/service/auth_local_service.dart';
import 'package:socket_io_admin_client/features/auth/presentation/providers/auth_email_provider.dart';
import 'package:socket_io_admin_client/features/chat/presentation/providers/add_chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController messageController = TextEditingController();
  final String fallbackProfileImg =
      "https://i.pinimg.com/736x/16/18/20/1618201e616f4a40928c403f222d7562.jpg";

  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    // IP Address
    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.5:8000/ws'));

    AppLogger.info('WebSocket connection initialized');

    channel.stream.listen((data) {
      AppLogger.info("Received from WebSocket: $data");

      try {
        final decoded = jsonDecode(data);
        final msg = decoded['message'];
        final sender = decoded['senderId'];

        if (msg != null && sender != null) {
          context.read<ChatProvider>().addIncomingChat(msg, sender);
        }
      } catch (e) {
        AppLogger.error("WebSocket decode error: $e");
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    messageController.dispose();
    AppLogger.info('WebSocket connection closed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Consumer<AuthEmailProvider>(
        builder: (context, authEmailProvider, _) {
          return KAppDrawer(
            name: currentUser?.displayName ?? 'No Name',
            email: currentUser?.email ?? 'No Email',
            role: AppDBConstants.admin,
            profileImageUrl: currentUser?.photoURL ?? fallbackProfileImg,
            onUpdatePress: () {
              // User Screen
              GoRouter.of(context).pushNamed(AppRouterConstants.user);
            },
            onSignOut: () async {
              // Sign Out
              await authEmailProvider.signOut();

              // Clear Auth Local Data
              await AuthLocalService.clearAuthData();

              AppLogger.success("User signed out successfully");

              // Auth Login
              GoRouter.of(
                context,
              ).pushReplacementNamed(AppRouterConstants.authLogin);
            },
          );
        },
      ),
      appBar: KAppBar(title: 'SOC Admin'),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: chatProvider.chats.length,
                  itemBuilder: (context, index) {
                    final chat = chatProvider.chats[index];
                    final isSender = chat.messageSender == currentUser?.uid;
                    return KChatBubble(
                      text: chat.chatMessage,
                      isSender: isSender,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: KTextFormField(
                        controller: messageController,
                        hintText: "Enter message",
                        prefixIcon: Icons.message,
                      ),
                    ),
                    KHorizontalSpacer(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: AppColorsConstants.blackColor,
                      onPressed: () {
                        // Message
                        final message = messageController.text.trim();

                        if (message.isNotEmpty && currentUser != null) {
                          // payload
                          final payload = jsonEncode({
                            "message": message,
                            "senderId": currentUser!.uid,
                            "timestamp": DateTime.now().toIso8601String(),
                          });

                          // Upload
                          channel.sink.add(payload);
                          AppLogger.success("Message sent via WebSocket");

                          // Clear
                          messageController.clear();
                        } else {
                          AppLogger.warn("Empty message or user null");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
