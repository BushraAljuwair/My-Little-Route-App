import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class ElvatedButton extends StatelessWidget {
  final String buttonTitle;
  final Color buttoColor;
  final Function()? onPressed;
  const ElvatedButton({
    super.key,
    required this.buttonTitle,
    required this.buttoColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(buttoColor),
        minimumSize: WidgetStateProperty.all(
          Size(context.getWidth() * .23, context.getHeight() * .049),
        ), // Smaller button size
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 10),
        ), // Adjust padding
        textStyle: WidgetStateProperty.all(
          StyleText.buttonText12(context).copyWith(color: StyleColor.white),
        ), // Ensure text color is white
      ),
      onPressed: onPressed,
      child: Text(buttonTitle.tr()),
    );
  }
}
