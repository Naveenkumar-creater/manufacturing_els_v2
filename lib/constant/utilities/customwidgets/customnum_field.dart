import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validation;
  final String hintText;
  final Function()? onEditingComplete;
   final void Function(String)? onChanged;
  final TextInputType? keyboardtype;
  final bool isAlphanumeric;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? border;
  final bool readOnly;
  final bool enabled; // Add this parameter for read-only functionality

  const CustomNumField({
    required this.controller,
    this.focusNode,
    this.validation,
    required this.hintText,
    this.onEditingComplete,
    this.onChanged,
    this.keyboardtype,
    this.isAlphanumeric = false,
    this.enabledBorder,
    this.focusedBorder,
    this.border,
    this.readOnly = false, 
    this.enabled=true
    // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
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
      enabled:enabled ,// Pass the readOnly parameter to TextFormField
    );
  }
}
