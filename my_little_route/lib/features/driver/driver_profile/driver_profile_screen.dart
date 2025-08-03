import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/driver/driver_profile/bloc/driver_profile_bloc.dart';
import 'package:my_little_route/features/driver/driver_profile/edit_location_screen.dart';
import 'package:my_little_route/features/driver/driver_profile/widgets/row/buildInfo_by_row.dart';
import 'package:my_little_route/features/driver/driver_profile/widgets/buttomsheet/edit_profile_buttomsheet.dart';

import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverProfileBloc()..add(GetDriverBusInfoEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text("profile".tr())),
            body: BlocConsumer<DriverProfileBloc, DriverProfileState>(
              listener: (BuildContext context, DriverProfileState state) {
                if (state is ErorrState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: StyleColor.red,
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final bloc = context.read<DriverProfileBloc>();
                if (state is LoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SuccessState) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                        top: 80,
                      ),
                      child: Card(
                        surfaceTintColor: StyleColor.mintCream,
                        shadowColor: StyleColor.blue,
                        clipBehavior: Clip.none,
                        margin: EdgeInsets.zero,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    alignment: Alignment.topRight,
                                    onPressed: () {
                                      editPrfileBottomsheet(context: context);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),

                                  IconButton(
                                    alignment: Alignment.topRight,
                                    onPressed: () {
                                      bloc.add(LogOutEvent());
                                      if (state is SuccessStatesignOut) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
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
                                    icon: Icon(
                                      Icons.logout,
                                      color: StyleColor.red,
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                    "assets/image/driver (2).png",
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: Text(
                                  "driverDetails".tr(),
                                  style: StyleText.bold20(context),
                                ),
                              ),
                              SizedBox(height: 8),

                              BuildinfoByRow(
                                titile: "name",
                                value: bloc.appGetit.user!.name,
                              ),
                              BuildinfoByRow(
                                titile: "phone",
                                value: bloc.appGetit.user!.phone,
                              ),
                              BuildinfoByRow(
                                titile: "email",
                                value: bloc.appGetit.user!.email,
                              ),
                              StyleSize.sizeH8,
                              GestureDetector(
                                onTap: () {
                                  //LatLng  result=
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BlocProvider.value(
                                          value: bloc,
                                          child: EditLocationScreen(),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    //
                                    Icon(
                                      Icons.location_on_sharp,
                                      color: StyleColor.red,
                                    ),
                                    StyleSize.sizeW8,
                                    Text(
                                      "Driver'shouse".tr(), // عنوان قسم الموقع
                                      style: StyleText.regular16Green(context),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: StyleColor.gray),
                              StyleSize.sizeH24,

                              Text(
                                "BusDetails".tr(),
                                style: StyleText.bold20(context),
                              ),
                              SizedBox(height: 16),

                              BuildinfoByRow(
                                titile: "BusNumber",
                                value: "${bloc.driverBus!.busNumber}",
                              ),
                              BuildinfoByRow(
                                titile: "Model",
                                value: bloc.driverBus!.model,
                              ),
                              Row(),

                              BuildinfoByRow(
                                titile: "Capacity",
                                value: bloc.driverBus!.capacity.toString(),
                              ),
                              BuildinfoByRow(
                                titile: "LicensePlate",
                                value: bloc.driverBus!.plateNumber,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Center(child: Text("notdata".tr()));
              },
            ),
          );
        },
      ),
    );
  }
}
