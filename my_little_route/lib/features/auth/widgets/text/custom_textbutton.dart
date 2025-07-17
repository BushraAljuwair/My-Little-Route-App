import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class CustomTextbutton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final String textButton;
  const CustomTextbutton({super.key, this.onPressed, required this.title, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: StyleText.boldBlue20(context)),
        TextButton(
          onPressed: onPressed,
          child: Text(textButton, style: StyleText.boldBlue20(context)),
        ),
      ],
    );
  }
}
