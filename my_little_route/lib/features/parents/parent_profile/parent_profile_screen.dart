import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/parents/parent_profile/bloc/parent_profile_bloc.dart';
import 'package:my_little_route/features/parents/parent_profile/edit_location_screen.dart';
import 'package:my_little_route/features/parents/parent_profile/widgets/buttomsheet/edit_profile_buttomsheet.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ParentProfileBloc()..add(GetParentAndChildInfoEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<ParentProfileBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text("profile".tr()),
              backgroundColor: StyleColor.blue,
              elevation: 0,
            ),
            body: BlocBuilder<ParentProfileBloc, ParentProfileState>(
              // Listening to SuccessState and ImageUploadedState to rebuild the UI
              builder: (context, state) {
                if (state is ErrorState) {
                  return Center(
                    child: Text(
                      state.message,
                      style: StyleText.bold18(
                        context,
                      ).copyWith(color: StyleColor.red),
                    ),
                  );
                } else {
                  // This part of the code will execute on SuccessState or ImageUploadedState
                  // and also for ParentProfileInitial after data is loaded.
                  final user = bloc.appGetit.user;

                  if (user == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SuccessState || state is UploadImageEvent) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.getHeight() * .36,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        alignment: Alignment.topRight,
                                        onPressed: () {
                                          editParentPrfileBottomsheet(
                                            context: context,
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      BlocListener<
                                        ParentProfileBloc,
                                        ParentProfileState
                                      >(
                                        listener: (context, state) {
                                          if (state is SuccessStatesignOut) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          } else if (state is ErrorsignOut) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                backgroundColor: StyleColor.red,
                                                content: Text(
                                                  "error in logout ${state.toString()}",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: IconButton(
                                          alignment: Alignment.topRight,
                                          onPressed: () {
                                            bloc.add(LogOutEvent());
                                          },
                                          icon: const Icon(
                                            Icons.logout,
                                            color: StyleColor.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      bloc.add(GetImageFromGalleryEvent());
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: StyleColor.softBlue,
                                      child: ClipOval(
                                        child:
                                            (user.imageUrl != null &&
                                                user.imageUrl!.isNotEmpty)
                                            ? Image.network(
                                                user.imageUrl!,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Image.asset(
                                                      "assets/image/mother.png",
                                                      fit: BoxFit.cover,
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                              )
                                            : Image.asset(
                                                "assets/image/mother.png",
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ),
                                      ),
                                    ),
                                  ),
                                  StyleSize.sizeH16,
                                  Text(
                                    user.name,
                                    style: StyleText.bold20(
                                      context,
                                    ).copyWith(color: StyleColor.blue),
                                  ),
                                  StyleSize.sizeH16,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.email,
                                        size: 20,
                                        color: StyleColor.gray,
                                      ),
                                      StyleSize.sizeW8,
                                      Text(
                                        user.email,
                                        style: StyleText.regular16(context),
                                      ),
                                    ],
                                  ),
                                  StyleSize.sizeH8,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 20,
                                        color: StyleColor.gray,
                                      ),
                                      StyleSize.sizeW8,
                                      Text(
                                        user.phone,
                                        style: StyleText.regular16(context),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider.value(
                                              value: bloc,
                                              child: EditParentLocationScreen(),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        //
                                        Icon(
                                          Icons.location_on_sharp,
                                          color: StyleColor.red,
                                        ),
                                        StyleSize.sizeW8,
                                        Text(
                                          "YourHome".tr(), // عنوان قسم الموقع
                                          style: StyleText.regular16Green(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            StyleSize.sizeH16,
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final child = bloc.childern![index];
                                UserModel? driver = bloc.drivers!.firstWhere(
                                  (driver) => driver.id == child.driverId,
                                );

                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${"child".tr()}: ${child.name} ",
                                          style: StyleText.bold16(context),
                                        ),
                                        StyleSize.sizeH8,
                                        Text(
                                          "${"gender".tr()}: ${child.gender ?? ""}",
                                          style: StyleText.regular16(context),
                                        ),
                                        StyleSize.sizeH8,
                                        Text(
                                          "${"driver".tr()}: ${driver.name}",
                                          style: StyleText.bold16(context),
                                        ),
                                        Text(
                                          "${"email".tr()}: ${driver.email}",
                                          style: StyleText.regular16(context),
                                        ),
                                        Text(
                                          "${"phone".tr()}: ${driver.phone}",
                                          style: StyleText.regular16(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  StyleSize.sizeH8,
                              itemCount: bloc.childern?.length ?? 0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }
}
