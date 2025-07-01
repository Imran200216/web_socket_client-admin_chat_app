import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_admin_client/core/constants/app_colors_constants.dart';

class KDropdownTextFormField<T> extends StatelessWidget {
  final List<T> items;
  final String? selectedValue;
  final String hintText;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  final InputDecoration? decoration;
  final Widget? prefixIcon; // ✅ Added
  final ButtonStyleData buttonStyleData;
  final IconStyleData iconStyleData;
  final DropdownStyleData? dropdownStyleData;
  final MenuItemStyleData menuItemStyleData;
  final String Function(T) itemToString;

  const KDropdownTextFormField({
    super.key,
    required this.items,
    this.selectedValue,
    required this.hintText,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.hintStyle,
    this.itemStyle,
    this.decoration,
    this.prefixIcon, // ✅ Accept from outside
    this.buttonStyleData = const ButtonStyleData(
      padding: EdgeInsets.only(right: 8),
    ),
    this.iconStyleData = const IconStyleData(
      icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
      iconSize: 24,
    ),
    this.dropdownStyleData,
    this.menuItemStyleData = const MenuItemStyleData(
      padding: EdgeInsets.symmetric(horizontal: 16),
    ),
    required this.itemToString,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      isExpanded: true,
      decoration:
          decoration ??
          InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppColorsConstants.primaryColor,
                width: 2,
              ),
            ),
          ),

      hint: Text(
        hintText,
        style:
            hintStyle ??
            GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColorsConstants.textFieldHintColor,
            ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemToString(item),
                style:
                    itemStyle ??
                    GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColorsConstants.blackColor,
                    ),
              ),
            ),
          )
          .toList(),
      value: selectedValue != null
          ? items.firstWhere(
              (element) => itemToString(element) == selectedValue,
              orElse: () => items.isNotEmpty ? items.first : null as T,
            )
          : null,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      buttonStyleData: buttonStyleData,
      iconStyleData: iconStyleData,
      dropdownStyleData:
          dropdownStyleData ??
          DropdownStyleData(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          ),
      menuItemStyleData: menuItemStyleData,
    );
  }
}

class KStringDropdownTextFormField extends KDropdownTextFormField<String> {
  KStringDropdownTextFormField({
    super.key,
    required super.items,
    super.selectedValue,
    required super.hintText,
    super.onChanged,
    super.onSaved,
    super.validator,
    super.hintStyle,
    super.itemStyle,
    super.decoration,
    super.prefixIcon,
    super.buttonStyleData,
    super.iconStyleData,
    super.dropdownStyleData,
    super.menuItemStyleData,
  }) : super(itemToString: (String item) => item);
}
