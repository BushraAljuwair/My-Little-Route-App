import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';

class AuthButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  bool? changeButtonColor;
    AuthButton({
    super.key,
    this.onPressed,
    required this.title,
    this.changeButtonColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ), // مثال على Padding
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: !changeButtonColor!
              ? Theme.of(context).elevatedButtonTheme.style
              : Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: WidgetStatePropertyAll(StyleColor.white),
                  foregroundColor: WidgetStatePropertyAll(StyleColor.black),
                ),
          onPressed: onPressed,
          child: Text(title.tr()),
        ),
      ),
    );
  }
}
