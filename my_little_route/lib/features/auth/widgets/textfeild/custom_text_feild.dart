import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class CustomTextFeild extends StatelessWidget {
  final String? hintText;
  String? Function(String?)? validator;
  TextEditingController controller;
  Function()? onPressed;
  bool? isPassworVisible;
  bool isPassword;
  bool isSecure;

  CustomTextFeild({
    super.key,
    this.hintText,
    required this.validator,
    required this.controller,
    this.isPassworVisible = false,
    this.onPressed,
    this.isPassword = false,
    this.isSecure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getHeight() * .06,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        obscureText: isSecure,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: StyleColor.gray, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: StyleColor.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: StyleColor.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: StyleColor.red, width: 2),
          ),
          //open eye Icons.remove_red_eye  Icon(Icons.visibility_off)
          suffix: isPassword
              ? IconButton(
                  onPressed: onPressed,
                  icon: isPassworVisible!
                      ? Icon(Icons.remove_red_eye)
                      : Icon(Icons.visibility_off),
                )
              : null,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}
