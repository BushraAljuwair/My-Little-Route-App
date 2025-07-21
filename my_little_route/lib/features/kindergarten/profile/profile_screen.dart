import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/kindergarten/profile/bloc/profile_bloc.dart';
import 'package:my_little_route/features/kindergarten/profile/widgets/row/profile_action.dart';
import 'package:my_little_route/features/kindergarten/profile/widgets/text/custom_text_profile.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(GetUserEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<ProfileBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("ProfileScreen")),
            body: Column(
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ErrorState) {
                      return Text(state.message);
                    }
                    if (state is SuccessState) {
                      return Column(
                        children: [
                          Container(
                            width: context.getWidth() * .95,
                            margin: EdgeInsets.all(16),
                            height: context.getHeight() * .2,
                            decoration: BoxDecoration(
                              border: Border.all(width: .5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StyleSize.sizeH8,
                                ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage: AssetImage(
                                      "assets/image/admin.png",
                                    ),
                                    radius: 40,
                                  ),
                                  title: Text(
                                    bloc.appGetit.user!.name,
                                    style: StyleText.bold24(context),
                                  ),
                                  subtitle: Text(
                                    "Administrator".tr(),
                                    style: StyleText.bold16(context),
                                  ),
                                ),
                                StyleSize.sizeH24,

                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextProfile(
                                          title: bloc.appGetit.user!.email,
                                          icon: Icons.email,
                                        ),
                                        CustomTextProfile(
                                          title: bloc.appGetit.user!.phone,
                                          icon: Icons.phone,
                                        ),
                                      ],
                                    ),
                                    StyleSize.sizeW48,

                                    ElevatedButton(
                                      style: Theme.of(context)
                                          .elevatedButtonTheme
                                          .style!
                                          .copyWith(
                                            minimumSize: WidgetStatePropertyAll(
                                              Size(
                                                context.getWidth() * .23,
                                                context.getHeight() * .042,
                                              ),
                                            ),
                                          ),
                                      onPressed: () {},
                                      child: Text("Edit".tr()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          ProfileAction(
                            icon: Icons.person_add_alt_1,
                            actionTitile: "AddAdmin",
                            onTap: () {
                              bloc.add(AddAdminEvent());
                            },
                          ),
                          ProfileAction(
                            actionTitile: "Logout",
                            icon: Icons.logout,
                            onTap: () {
                              bloc.add(LogoutEvent());
                            },
                          ),
                          ProfileAction(
                            icon: Icons.delete_forever,
                            actionTitile: "Delete Account",
                            onTap: () {
                              bloc.add(DeleteAccountEvent());
                            },
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
