import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KTextBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool isUnderline; // 🔹 NEW

  const KTextBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.textStyle,
    this.color,
    this.padding,
    this.isUnderline = false, // 🔹 DEFAULT false
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).primaryColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style:
            textStyle?.copyWith(
              decoration: isUnderline
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ) ??
            GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration: isUnderline
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
      ),
    );
  }
}
