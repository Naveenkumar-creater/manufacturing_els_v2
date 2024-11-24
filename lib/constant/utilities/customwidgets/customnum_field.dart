import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validation;
  final String hintText;
  final Function()? onEditingComplete;
  final Function()? onSubmitted;
    final Function()? onTap;

  final void Function(String)? onChanged;
  final void Function(bool)? onFocusChange; // Add this parameter for focus change callback
  final TextInputType? keyboardtype;
  final bool isAlphanumeric;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? border;
  final bool readOnly;
  final bool enabled;

  const CustomNumField({
    required this.controller,
    this.focusNode,
    this.validation,
    required this.hintText,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.onFocusChange, // Include onFocusChange in the constructor
    this.keyboardtype,
    this.isAlphanumeric = false,
    this.enabledBorder,
    this.focusedBorder,
    this.border,
    this.readOnly = false,
    this.enabled = true,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    // Use a local FocusNode if one is not provided
    final effectiveFocusNode = focusNode ?? FocusNode();

    // Listen to focus changes
    effectiveFocusNode.addListener(() {
      if (onFocusChange != null) {
        onFocusChange!(effectiveFocusNode.hasFocus);
      }
    });

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      focusNode: effectiveFocusNode,
      keyboardType: keyboardtype ?? TextInputType.number,
      inputFormatters: [
        if (!isAlphanumeric) FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 40, maxWidth: 200),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(
          fontSize: 10.0,
          height: 0.10,
        ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
      ),
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      validator: validation,
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
    );
  }
}
