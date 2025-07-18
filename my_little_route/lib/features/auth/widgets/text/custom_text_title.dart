import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_text.dart';

class CustomTextTitle extends StatelessWidget {
  final String title;
  bool isHeader;
    CustomTextTitle({super.key, required this.title, this.isHeader=false});
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style:!isHeader? StyleText.bold20(context): StyleText.bold24(context)),
    );
  }
}
