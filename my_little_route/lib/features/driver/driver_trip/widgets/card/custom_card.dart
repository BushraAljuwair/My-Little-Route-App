import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class CustomCard extends StatelessWidget {
  final String tripTitle;
  final Function()? onTap;
   final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final Color cardBackgroundColor;

  const CustomCard({
    super.key,
    required this.tripTitle,
    this.onTap,
    required this.icon,
    required this.iconColor,
    required this.buttonColor,
    required this.cardBackgroundColor,
   });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      focusColor: StyleColor.red,
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(horizontal: context.getWidth() * 0.05),
        child: Container(
          width: context.getWidth() * .9,
          height: context.getHeight() * .18,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: context.getWidth() * 0.08),
              const SizedBox(width: 12),
              Text(tripTitle.tr(), style: StyleText.bold20(context)),
            ],
          ),
        ),
      ),
    );
  }
}
