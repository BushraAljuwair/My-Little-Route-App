import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/widgets/button/auth_button.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_text_title.dart';
import 'package:my_little_route/features/auth/widgets/textfeild/custom_text_feild.dart';
import 'package:my_little_route/features/kindergarten/add_admin/bloc/add_admin_bloc.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';
import 'package:my_little_route/utilities/helper/auth_validator.dart';

class AddAdminScree extends StatelessWidget {
  const AddAdminScree({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAdminBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AddAdminBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("Addadmin".tr()), centerTitle: true),
            body: Form(
              key: bloc.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: CustomTextTitle(title: "newadmin")),
                    StyleSize.sizeH16,
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

                    CustomTextTitle(title: "password"),
                    BlocBuilder<AddAdminBloc, AddAdminState>(
                      builder: (context, state) {
                        return CustomTextFeild(
                          onPressed: () {
                            bloc.add(TogglePasswordVisibilityEvent());
                          },
                          isPassword: true,
                          isPassworVisible: bloc.isPasswordVisible,
                          isSecure: bloc.isSecure,
                          validator: (value) => validatePassword(value),
                          controller: bloc.controllerPassword,
                        );
                      },
                    ),
                    CustomTextTitle(title: "confirmpassword"),
                    BlocConsumer<AddAdminBloc, AddAdminState>(
                      listener: (BuildContext context, AddAdminState state) {
                        if (state is SuccsessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("administratoradded".tr())),
                          );
                        } else if (state is ErrorInAddAdimnState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomTextFeild(
                          onPressed: () {
                            bloc.add(TogglePasswordVisibilityEvent());
                          },

                          isSecure: true,
                          validator: (value) => validateConfirmPassword(
                            value,
                            bloc.controllerPassword.text,
                          ),
                          controller: bloc.controllerConformPassword,
                        );
                      },
                    ),

                    AuthButton(
                      title: "Addadmin",
                      onPressed: () {
                        if (bloc.formKey.currentState!.validate()) {
                          log("Form is valid!");
                          bloc.add(AddNewAdminEvent());
                        } else {
                          log("Form is invalid!");
                        }
                      },
                    ),
                    AuthButton(
                      changeButtonColor: true,
                      title: "Cancel",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
