import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';

class KChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const KChatBubble({super.key, required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialOne(
      text: text,
      isSender: isSender,
      color: AppColorsConstants.yellowChatBubbleBg,
      textStyle: TextStyle(
        fontSize: 16,
        color: AppColorsConstants.yellowChatBubbleText,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
