import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';

class KTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const KTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<KTextFormField> createState() => _KTextFormFieldState();
}

class _KTextFormFieldState extends State<KTextFormField> {
  bool _obscure = true;

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
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscure : false,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        cursorColor: AppColorsConstants.primaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: AppColorsConstants.textFieldHintColor,
          ),
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColorsConstants.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
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
