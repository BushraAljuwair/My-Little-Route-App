import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
 

 void showAlertDilog({
  required BuildContext context,
  required String content,
  VoidCallback? onConfirm,  
}) {
 
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirm".tr()),  
      content: Text(content.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel".tr()),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm();  
            } else {
             }
            Navigator.pop(context);
          },
          child: Text("Yes".tr()),
        ),
      ],
    ),
  );
}
