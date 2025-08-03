import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/driver/nav/driver_nav_screen.dart';
import 'package:my_little_route/features/nav/nav_screen.dart';
import 'package:my_little_route/features/parents/nav/parent_nav_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class LoadingScreen extends StatelessWidget {
//   const LoadingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//    final  appGetit=GetIt.I.get<AppDataLayer>();
//     return Scaffold(

//       body: StreamBuilder(
//         stream: Supabase.instance.client.auth.onAuthStateChange,
//         builder: (context, snapshot)  {
//           final authState = snapshot.data;
//           if (authState == null) {
//             //error
//             return Text("error ");
//           } else {
//             final session = authState.session;
//             if (session != null)  {
//                  appGetit.getUser(id: session.user.id);
//                 if(appGetit.user!.role=="admin")
//              {
//                return NavScreen();//user loggd in
//              }else    if(appGetit.user!.role=="driver"){
//               return  DriverNavScreen();
//              }else  {
//                   return ParentNavScreen();
//              }
//             } else {
//               return LoginScreen();//user not log in
//             }
//           }

//         },
//       ),
//     );
//   }
// }

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appGetit = GetIt.I.get<AppDataLayer>();

    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final authState = snapshot.data;

          if (authState == null) {
            return const LoginScreen();

            // return const Center(child: CircularProgressIndicator());
          }

          final session = authState.session;
          if (session == null) {
            return const LoginScreen();
          }

          return FutureBuilder(
            future: appGetit.getUser(id: session.user.id),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (appGetit.user == null) {
                return const Center(child: Text("خطأ في تحميل المستخدم"));
              }

              if (appGetit.user!.role == "admin") {
                return const NavScreen();
              } else if (appGetit.user!.role == "driver") {
                return const DriverNavScreen();
              } else {
                return const ParentNavScreen();
              }
            },
          );
        },
      ),
    );
  }
}
