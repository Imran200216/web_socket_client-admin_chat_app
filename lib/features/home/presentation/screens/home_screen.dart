import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_admin_client/commons/widgets/KAppBar.dart';
import 'package:socket_io_admin_client/commons/widgets/KAppDrawer.dart';
import 'package:socket_io_admin_client/commons/widgets/KChatBubble.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';
import 'package:socket_io_admin_client/core/constants/app_router_constants.dart';
import 'package:socket_io_admin_client/core/logger/app_logger.dart';
import 'package:socket_io_admin_client/core/service/auth_local_service.dart';
import 'package:socket_io_admin_client/features/auth/presentation/providers/auth_email_provider.dart';
import 'package:socket_io_admin_client/features/chat/presentation/providers/add_chat_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // current user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Fallback img
  final String fallbackProfileImg =
      "https://i.pinimg.com/736x/16/18/20/1618201e616f4a40928c403f222d7562.jpg";

  // Web Socket Channel
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.5:8000/ws'));

    channel.stream.listen((data) {
      AppLogger.info("💡 Received from WebSocket: $data");

      try {
        final decoded = jsonDecode(data);

        if (decoded is List) {
          // First response: all previous messages
          for (final msg in decoded) {
            context.read<ChatProvider>().addIncomingChat(
              msg['message'],
              msg['senderId'],
            );
          }
        } else if (decoded is Map) {
          // Real-time single message
          context.read<ChatProvider>().addIncomingChat(
            decoded['message'],
            decoded['senderId'],
          );
        }
      } catch (e) {
        AppLogger.error("WebSocket decode error: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Consumer<AuthEmailProvider>(
        builder: (context, authEmailProvider, child) {
          return KAppDrawer(
            name: currentUser?.displayName ?? 'No Name',
            email: currentUser?.email ?? 'No Email',
            role: "admin",
            profileImageUrl: currentUser?.photoURL ?? fallbackProfileImg,
            onSignOut: () async {
              // Sign out
              await authEmailProvider.signOut();

              // Clear All Storage Status
              await AuthLocalService.clearAuthData();

              // Auth Login Screen
              GoRouter.of(
                context,
              ).pushReplacementNamed(AppRouterConstants.authLogin);
            },
          );
        },
      ),
      appBar: KAppBar(title: 'SOC Client'),
      body: Stack(
        children: [
          // body
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                child: ListView.builder(
                  itemCount: chatProvider.chats.length,
                  itemBuilder: (context, index) {
                    final chat = chatProvider.chats[index];

                    return KChatBubble(
                      text: chat.chatMessage,
                      isSender: chat.messageSender == currentUser?.uid,
                    );
                  },
                ),
              );
            },
          ),

          Consumer<AuthEmailProvider>(
            builder: (context, authEmailProvider, child) {
              return authEmailProvider.isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColorsConstants.whiteColor,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColorsConstants.primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
