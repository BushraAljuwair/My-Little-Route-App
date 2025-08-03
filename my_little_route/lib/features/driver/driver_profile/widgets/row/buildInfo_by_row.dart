import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BuildinfoByRow extends StatelessWidget {
  final String titile;
  final String value;
  const BuildinfoByRow({super.key, required this.titile, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "${titile.tr()}:\t",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
