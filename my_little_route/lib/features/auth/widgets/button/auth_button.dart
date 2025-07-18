import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  const AuthButton({super.key, this.onPressed, required this.title});

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
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: onPressed,
          child:  Text(title),
        ),
      ),
    );
  }
}
