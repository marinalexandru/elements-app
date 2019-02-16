import 'package:flutter/material.dart';
import 'package:elements/utils/color_theme.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final String error;
  final bool enabled;

  AppTextField(
      {this.label = "label",
      this.hint = "hint",
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.error,
      this.enabled = true});

  @override
  Widget build(BuildContext context) => TextField(
        decoration: _buildStyle(),
        obscureText: obscureText,
        onChanged: onChanged,
        enabled: enabled,
        style: TextStyle(letterSpacing: 1.3, fontSize: 14),
        keyboardType: keyboardType,
      );

  _buildStyle() => InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(7.0)),
        ),
        filled: true,
        fillColor: ColorTheme.dark_blue_384A64_alpha22,
        labelText: label,
        hintText: hint,
        errorText: error,
        errorStyle: TextStyle(letterSpacing: 1.3, fontSize: 12),
        hintStyle: TextStyle(letterSpacing: 2, fontSize: 13),
        labelStyle: TextStyle(letterSpacing: 2, fontSize: 14),
      );
}
