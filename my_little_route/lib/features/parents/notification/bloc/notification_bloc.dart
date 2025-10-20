import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/notifications/notifications_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final appGetIt = GetIt.I.get<AppDataLayer>();
  final authGetIt = GetIt.I.get<AuthServiceLayer>();
  StreamSubscription? notificationsSubscription;
  List<NotificationsModel>?notifcation;
  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotificationEvent>(getNotificationMethod);
  }

  FutureOr<void> getNotificationMethod(
    GetNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
     try {
      if (appGetIt.user == null) {
        await appGetIt.getUser(id: authGetIt.currentUser!.id);
      }
      final notificationsStrem =   appGetIt.notificationsMessage(
        userId: appGetIt.user!.id!,
      );
      int count=1;
    
      notificationsSubscription = notificationsStrem.listen((data) {
       
        log("$count  -  ${data.toString()}");
        count++;
 
      });
    //    for (var element in notifcation!) {
    //   log(element.toString());
      
    // }
      emit(SucssesState());
    } on Exception catch (e) {
      emit(ErrorNotificationState(message: e.toString()));
    }
  }
}
