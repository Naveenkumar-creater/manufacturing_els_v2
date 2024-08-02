import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed; // Allow onPressed to be nullable
  final Widget child;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final BoxBorder? border;
  final Color disabledColor;

  CustomButton({
    required this.width,
    required this.height,
    required this.child,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.disabledColor = Colors.grey, // Default disabled color
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isEnabled ? backgroundColor : disabledColor,
          borderRadius: borderRadius,
          border: border,
        ),
        child: Center(child: child),
      ),
    );
  }
}
