import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/bloc/auth_bloc.dart';
import 'package:my_little_route/features/auth/widgets/button/auth_button.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_text_title.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_textbutton.dart';
import 'package:my_little_route/features/auth/widgets/textfeild/custom_text_feild.dart';
 import 'package:my_little_route/features/nav/nav_screen.dart';
import 'package:my_little_route/utilities/helper/auth_validator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AuthBloc>();
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: bloc.formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextTitle(title: "LogIn", isHeader: true),
                    CustomTextTitle(title: "email"),
                    CustomTextFeild(
                      validator: (value) => validateEmail(value),
                      controller: bloc.controllerEmail,
                    ),
                    CustomTextTitle(title: "password".tr()),
                    BlocBuilder<AuthBloc, AuthState>(
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

                    AuthButton(
                      title: "LogIn".tr(),
                      onPressed: () {
                        if (bloc.formKey.currentState!.validate()) {
                          log("Form is valid!");
                          bloc.add(LogInEvent());
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (contex) => NavScreen()),
                          );
                        } else {
                          log("Form is invalid!");
                        }
                      },
                    ),
                    CustomTextbutton(
                      title: "noaccount?".tr(),
                      textButton: "SignUp".tr(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (contex) => LoginScreen()),
                        );
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
