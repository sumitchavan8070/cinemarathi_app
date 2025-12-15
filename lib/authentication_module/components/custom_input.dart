import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/blurry_container.dart';

class CommonInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Color fillColor;
  final double blur;

  const CommonInputField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isPassword = false,
    this.fillColor = const Color.fromARGB(30, 255, 255, 255),
    this.blur = 0,
    this.obscureText = false,
    this.hintText = "", // Set blur > 0 for glass-like UI
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade300)),
        const SizedBox(height: 6),
        BlurryContainer(
          color: Colors.white.withOpacity(0.06),
          height: 60,
          borderColor: Colors.white.withOpacity(0.12),
          // borderWidth: 1,

          borderRadius: BorderRadius.all(Radius.circular(16)),

          child: TextFormField(
            controller: controller,
            obscureText: obscureText,

            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              hintText: label,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
