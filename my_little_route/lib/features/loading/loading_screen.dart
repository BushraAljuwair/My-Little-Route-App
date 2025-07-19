import 'package:flutter/material.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/nav/nav_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final authState = snapshot.data;
          if (authState == null) {
            //error 
            return Text("error ");
          } else {
            final session = authState.session;
            if (session != null) {
              return NavScreen();//user loggd in 
            } else {
              return LoginScreen();//user not log in 
            }
          }
           
        },
      ),
    );
  }
}
