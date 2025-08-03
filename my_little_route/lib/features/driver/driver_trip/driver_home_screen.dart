import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/driver/driver_trip/bloc/driver_trip_bloc.dart';
import 'package:my_little_route/features/driver/driver_trip/driver_trip_screen.dart';
import 'package:my_little_route/features/driver/driver_trip/widgets/card/custom_card.dart';
import 'package:my_little_route/repository/supabase.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverTripBloc()..add(GetDriverAndStudentsEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<DriverTripBloc>();
          return Scaffold(
            backgroundColor: StyleColor.offWhite,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StyleSize.sizeH24,
                      Text("StartTrip".tr(), style: StyleText.bold36(context)),
                      StyleSize.sizeH8,
                      Text(
                        "tripbegintracking".tr(),
                        style: StyleText.bold16(context),
                      ),
                      SizedBox(
                        width: context.getWidth() * .7,
                        child: Image.asset('assets/image/driver_image.png'),
                      ),
                      StyleSize.sizeH32,
                      CustomCard(
                        iconColor: StyleColor.buttonOrange,
                        tripTitle: "MorningTrip1",
                        onTap: () {
                          if(bloc.sharedPrefs.getString("trip_id")==null) {
                            log("1234567890-0987654321");
                            bloc.add(CreateTripEvent());
                          }else{
                            bloc.add(GetTripEvent());
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider.value(
                                  value: bloc,
                                  child: DriverTripScreen(),
                                );
                              },
                            ),
                          );
                        },
                        icon: Icons.sunny,
                        buttonColor: StyleColor.buttonOrange,
                        cardBackgroundColor: StyleColor.white,
                      ),
                      StyleSize.sizeH16,
                      CustomCard(
                        tripTitle: "ReturnTrip",
                        onTap: () {
                          bloc.add(CreateReturnTripEvent());
                        },
                        icon: Icons.house,
                        iconColor: StyleColor.lapislazuli,
                        buttonColor: StyleColor.lapislazuli,
                        cardBackgroundColor: StyleColor.softBlue,
                      ),
                      StyleSize.sizeH24,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
