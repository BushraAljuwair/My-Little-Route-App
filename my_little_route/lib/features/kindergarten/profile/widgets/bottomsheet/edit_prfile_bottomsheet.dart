import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/widgets/button/auth_button.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_text_title.dart';
import 'package:my_little_route/features/auth/widgets/textfeild/custom_text_feild.dart';
import 'package:my_little_route/features/kindergarten/profile/bloc/profile_bloc.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';
import 'package:my_little_route/utilities/helper/auth_validator.dart';

void editPrfileBottomsheet({required BuildContext context}) async {
  final bloc = context.read<ProfileBloc>();
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    context: (context),
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 12
          ),
          child: 
               SizedBox(
                width: context.getWidth(),
                height: context.getHeight() * .7,
                child: Form(
                  key: bloc.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text("Editprofile".tr(),style: StyleText.bold20(context),)),
                      CustomTextTitle(title: "Fullname".tr()),
                      CustomTextFeild(
                        validator: (value) => validateFullName(value),
                        controller: bloc.controllerName,
                      ),
                  
                      CustomTextTitle(title: "email"),
                      CustomTextFeild(
                        validator: (value) => validateEmail(value),
                        controller: bloc.controllerEmail,
                      ),
                  
                      CustomTextTitle(title: "phone"),
                      CustomTextFeild(
                        validator: (value) => validatePhone(value),
                        controller: bloc.controllerPhone,
                      ),
                  
                      AuthButton(
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
                    ],
                  ),
                ),
             
           
          ),
        ),
      );
    },
  );
}
