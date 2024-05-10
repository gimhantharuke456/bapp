import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool enabled;
  const CustomInputField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.obscureText = false,
      this.validator,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
