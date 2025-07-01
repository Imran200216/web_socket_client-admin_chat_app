import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';

class KUIDGeneratableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback onSuffixIconTap;

  const KUIDGeneratableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    required this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColorsConstants.primaryColor,
          selectionColor: AppColorsConstants.primaryColor.withOpacity(0.4),
          selectionHandleColor: AppColorsConstants.primaryColor,
        ),
      ),
      child: TextFormField(
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: AppColorsConstants.blackColor,
        ),
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        cursorColor: AppColorsConstants.primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: AppColorsConstants.textFieldHintColor,
          ),
          prefixIcon: Icon(prefixIcon, color: AppColorsConstants.primaryColor),
          suffixIcon: IconButton(
            onPressed: () {
              onSuffixIconTap();
            },
            icon: Icon(suffixIcon, color: AppColorsConstants.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColorsConstants.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
