import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';
 class StudentSwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;
  final String title;

  const StudentSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: StyleColor.mintCream,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: value
                ? StyleColor.lapislazuli
                : Colors.grey.shade400,
            child: Icon(
              Icons.directions_bus,
              color: Colors.white,
            ),
          ),
          title: Text(
            title,
            style: StyleText.bold16(context),
          ),
          trailing: Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: StyleColor.buttonOrange,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
