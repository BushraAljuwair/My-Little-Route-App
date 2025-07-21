import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class CustomListtile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String tralingTitle;
  final Function()? onTap;
  const CustomListtile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.tralingTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Card(
        color: color,
        child: Container(
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(icon, size: 30),
            title: Text(title.tr()),
            trailing: Text(tralingTitle.tr()),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
