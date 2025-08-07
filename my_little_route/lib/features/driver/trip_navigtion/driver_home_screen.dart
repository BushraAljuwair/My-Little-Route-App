import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/driver/trip_navigtion/trip_navigtion_screen.dart';
import 'package:my_little_route/features/driver/driver_trip/widgets/card/custom_card.dart';
import 'package:my_little_route/features/driver/trip_navigtion/bloc/trip_navigtion_bloc.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class DriverHomeScreen1 extends StatelessWidget {
  const DriverHomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TripNavigtionBloc()..add(GetDriverAndStudentsEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<TripNavigtionBloc>();
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
                            bloc.add(CreatePickUpEvent());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider.value(
                                  value: bloc,
                                  child: TripNavigtionScreen(),
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
                        onTap: () {},
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
