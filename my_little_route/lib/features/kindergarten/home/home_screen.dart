import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/kindergarten/home/bloc/home_bloc.dart';
import 'package:my_little_route/features/kindergarten/home/widgets/listtile/custom_listtile.dart';
import 'package:my_little_route/features/kindergarten/home/widgets/text/custom_text.dart';
import 'package:my_little_route/features/kindergarten/view_drivers_screen.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<HomeBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("HomeScreen")),
            body: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    CustomText(title: "${'Hello' .tr()} ${bloc.user?.name}"),
                    StyleSize.sizeH16,
                    CustomListtile(
                      onTap: (){
                        //Supabase.instance.client.auth.signOut();
                      }
                      ,
                      title: "Buses",
                      icon: Icons.directions_bus,
                      color: StyleColor.blue,
                      tralingTitle: "12 active / 3",
                    ),
                     CustomListtile(
                      onTap: (){
log("message");
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewDriversScreen()));
                      }
                      ,
                      title: "Drivers",
                      icon: Icons.person,
                      color: StyleColor.seaGreen,
                      tralingTitle: "12 active / 3",
                    ),
                     CustomListtile(
                      onTap: (){
                        
                      }
                      ,
                      title: "Students",
                      icon: Icons.person,
                      color: StyleColor.indigo,
                      tralingTitle: "12 active / 3",
                    ),
                       CustomListtile(
                      onTap: (){
                        //Supabase.instance.client.auth.signOut();
                      }
                      ,
                      title: "Trips",
                      icon: Icons.location_on,
                      color: StyleColor.maize,
                      tralingTitle: "12 active / 3",
                    ),
                    
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
