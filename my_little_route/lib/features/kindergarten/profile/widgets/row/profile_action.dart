import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';

class ProfileAction extends StatelessWidget {
  final String actionTitile;
  final Function()? onTap;
  final IconData icon;

  const ProfileAction({
    super.key,
    required this.actionTitile,
    this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: StyleColor.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: StyleColor.blue, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                actionTitile.tr(),
                style: StyleText.regularBlue20(context),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
