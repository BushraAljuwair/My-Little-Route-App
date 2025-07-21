import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/features/auth/bloc/auth_bloc.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/auth/widgets/button/auth_button.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_text_title.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_textbutton.dart';
import 'package:my_little_route/features/auth/widgets/textfeild/custom_text_feild.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/utilities/helper/auth_validator.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AuthBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("SignUp".tr()), centerTitle: true),
            body: Form(
              key: bloc.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.getWidth(),
                      height: context.getHeight() * .2,
                      child: Image.asset("assets/image/bus.png"),
                    ),

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
                    CustomTextTitle(title: "confirmpassword"),
                    BlocBuilder<AuthBloc, AuthState>(
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
                      title: "CreateAccount",
                      onPressed: () {
                        if (bloc.formKey.currentState!.validate()) {
                          log("Form is valid!");
                          bloc.add(SignUPEvent());
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        } else {
                          log("Form is invalid!");
                        }
                      },
                    ),
                    CustomTextbutton(
                      title: "haveacount",
                      textButton:  "LogIn",
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
