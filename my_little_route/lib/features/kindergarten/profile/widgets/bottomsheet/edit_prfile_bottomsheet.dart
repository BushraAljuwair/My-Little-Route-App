import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/widgets/button/auth_button.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_text_title.dart';
import 'package:my_little_route/features/auth/widgets/textfeild/custom_text_feild.dart';
import 'package:my_little_route/features/kindergarten/profile/bloc/profile_bloc.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';
import 'package:my_little_route/utilities/helper/auth_validator.dart';

void editPrfileBottomsheet({required BuildContext context}) async {
  final bloc = context.read<ProfileBloc>();
   
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 24.0,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: bloc.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Editprofile".tr(),
                      style: StyleText.bold20(context),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildInputField(
                    context,
                    "Fullname",
                    bloc.controllerName,
                    validateFullName,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    context,
                    "email",
                    bloc.controllerEmail,
                    validateEmail,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    context,
                    "phone",
                    bloc.controllerPhone,
                    validatePhone,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: AuthButton(
                      title: "Editprofile",
                      onPressed: () {
                        if (bloc.formKey.currentState!.validate()) {
                          log("Form is valid!");
                          bloc.add(UpdateUserInfoEvent());
                        } else {
                          log("Form is invalid!");
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInputField(
  BuildContext context,
  String title,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomTextTitle(title: title),
      SizedBox(height: 8),
      CustomTextFeild(validator: validator, controller: controller),
    ],
  );
}
