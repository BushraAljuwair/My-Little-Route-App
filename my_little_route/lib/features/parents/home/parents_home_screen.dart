import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_little_route/features/parents/home/bloc/parent_home_bloc.dart';
import 'package:my_little_route/features/parents/notification/notification_screen.dart';
import 'package:my_little_route/features/parents/tracking/tracking_screen.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:my_little_route/style/style_text.dart';

class ParentsHomeScreen extends StatelessWidget {
  const ParentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentHomeBloc()..add(GetUserInfoEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<ParentHomeBloc>();
          return Scaffold(
            backgroundColor: StyleColor.teal,
            body: SafeArea(
              child: BlocBuilder<ParentHomeBloc, ParentHomeState>(
                builder: (context, state) {
                  if (state is ParentErrorState) {
                    return Center(child: Text(state.message));
                  }
  if(state is SucssesState){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),

                        // صورة الطفل + الجرس
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundImage: AssetImage(
                                    "assets/image/marker-girl.png",
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // التحية
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${"Hello".tr()} ${bloc.appGetIt.user!.name}",
                            style: StyleText.bold30(context).copyWith(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // زر تتبع الباص
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackingScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: StyleColor.yellowOrange,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/image/parent_bus.png",
                                  width: 40,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                   "Trackbus".tr(),
                                  style: StyleText.bold20(
                                    context,
                                  ).copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );}
                  return Center(child: Text("wait"),);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
