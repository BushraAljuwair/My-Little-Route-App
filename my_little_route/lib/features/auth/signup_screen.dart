import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_little_route/features/auth/bloc/auth_bloc.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_text_title.dart';
import 'package:my_little_route/features/auth/widgets/text/custom_textbutton.dart';
import 'package:my_little_route/features/auth/widgets/textfeild/custom_text_feild.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            appBar: AppBar(title: Text("Sign up"), centerTitle: true),
            body: Form(
              key: bloc.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: StyleColor.blue,
                      width: context.getWidth(),
                      height: context.getHeight() * .2,
                    ),

                    CustomTextTitle(title: "Full name"),
                    CustomTextFeild(
                      validator: (value) {
                        log("value      $value");
                        final RegExp nameRegExp = RegExp(
                          r'^[\u0621-\u064Aa-zA-Z]+(?: [\u0621-\u064Aa-zA-Z]+)+$',
                        );
                        if (value == null || value.isEmpty) {
                          return 'The name should not be empty';
                        }

                        if (!nameRegExp.hasMatch(value)) {
                          return "The name must consist of the first and last name.";
                        }
                        return null;
                      },
                      controller: bloc.controllerName,
                    ),

                    CustomTextTitle(title: "email"),
                    CustomTextFeild(
                      validator: (value) {
                        log("value      $value");
                        final RegExp emailRegExp = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (value == null || value.isEmpty) {
                          return 'The email should not be empty';
                        }

                        if (!emailRegExp.hasMatch(value)) {
                          return "Invalid email. Example: name@example.com";
                        }
                        return null;
                      },
                      controller: bloc.controllerEmail,
                    ),

                    CustomTextTitle(title: "phone"),
                    CustomTextFeild(
                      validator: (value) {
                        log("value      $value");
                        final RegExp emailRegExp = RegExp(r'^\d{10}$');
                        if (value == null || value.isEmpty) {
                          return 'The phone should not be empty';
                        }

                        if (!emailRegExp.hasMatch(value)) {
                          return "Invalid phone number, phone number must be 10 digits";
                        }
                        return null;
                      },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "The password cannot be empty.";
                            }

                            // Here you place the regular expression for password validation
                            // Condition 1: At least 8 characters long
                            if (value.length < 8) {
                              return "The password must be at least 8 characters long.";
                            }
                            // Condition 2: At least one uppercase letter
                            if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                              return "Must contain at least one uppercase letter.";
                            }
                            // Condition 3: At least one lowercase letter
                            if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                              return "Must contain at least one lowercase letter.";
                            }
                            // Condition 4: At least one digit
                            if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                              return "Must contain at least one digit.";
                            }
                            // Condition 5: At least one special character
                            if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                              return "Must contain at least one special character.";
                            }

                            return null; // If all conditions are met
                          },
                          controller: bloc.controllerPassword,
                        );
                      },
                    ),
                    CustomTextTitle(title: "confirm password"),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomTextFeild(
                          onPressed: () {
                            bloc.add(TogglePasswordVisibilityEvent());
                          },

                          isSecure: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "The password cannot be empty.";
                            }

                            if (value != bloc.controllerPassword.text) {
                              return "passwords must be same values";
                            }
                            // Here you place the regular expression for password validation
                            // Condition 1: At least 8 characters long
                            if (value.length < 8) {
                              return "The password must be at least 8 characters long.";
                            }
                            // Condition 2: At least one uppercase letter
                            if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                              return "Must contain at least one uppercase letter.";
                            }
                            // Condition 3: At least one lowercase letter
                            if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                              return "Must contain at least one lowercase letter.";
                            }
                            // Condition 4: At least one digit
                            if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                              return "Must contain at least one digit.";
                            }
                            // Condition 5: At least one special character
                            if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                              return "Must contain at least one special character.";
                            }

                            return null; // If all conditions are met
                          },
                          controller: bloc.controllerConformPassword,
                        );
                      },
                    ),

                    Padding(
                      // يمكنك إضافة Padding حول الزر إذا أردت مسافة من الجوانب
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ), // مثال على Padding
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          onPressed: () {
                            if (bloc.formKey.currentState!.validate()) {
                              log("Form is valid!");
                            } else {
                              log("Form is invalid!");
                            }
                          },
                          child: const Text("Create Account"),
                        ),
                      ),
                    ),
                    CustomTextbutton(title: "Already have acount?",textButton: "Log in",onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex)=>LoginScreen()));

                    },)
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
