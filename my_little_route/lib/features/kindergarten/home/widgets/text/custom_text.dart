import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_text.dart';

class CustomText extends StatelessWidget {
  final String title;
  const CustomText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title.tr(),style: StyleText.bold24(context),);
  }
}
