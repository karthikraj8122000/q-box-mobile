import 'package:flutter/material.dart';

import '../../../../../Utils/validator.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? suffixIcon;
  final List<ValidationRule> validationRules;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onchange;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.suffixIcon,
    required this.validationRules,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onchange
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onchange,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        filled: true,
        border: const UnderlineInputBorder(borderSide: BorderSide.none),
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
      ),
      validator: (value) => Validator.validate(value, validationRules),
    );
  }
}
