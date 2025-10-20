import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/parents/notification/bloc/notification_bloc.dart';
import 'package:my_little_route/models/notifications/notifications_model.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   // In your NotificationScreen class
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => NotificationBloc()..add(GetNotificationEvent()),
//       child: Scaffold(
//         appBar: AppBar(),
//         body: BlocBuilder<NotificationBloc, NotificationState>(
//           builder: (context, state) {
//             if (state is SucssesState) {
//               final List<NotificationsModel> noti = context
//                   .read<NotificationBloc>()
//                   .notifcation!;
//               if (noti.isEmpty) {
//                 return Center(child: Text('No notifications to display.'));
//               }
//               // Use Expanded to give the ListView a bounded height within the Column
//               return Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: noti.length,
//                       itemBuilder: (context, index) {
//                         final currentNoti = noti[index];
//                         // Return a widget here, for example a Text widget
//                         return ListTile(title: Text(currentNoti.message));
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else if (state is ErrorNotificationState) {
//               return Center(child: Text(state.message));
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc()..add(GetNotificationEvent()),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(children: [Text("data")]),
      ),
    );
  }
}
