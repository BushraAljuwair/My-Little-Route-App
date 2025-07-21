import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final authServiceGetit=GetIt.I.get<AuthServiceLayer>();
    final appGetit=GetIt.I.get<AppDataLayer>();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetUserEvent>(getUserMethod);
    on<AddAdminEvent>(addAdminEventMethod);
  }

  FutureOr<void> getUserMethod(GetUserEvent event, Emitter<ProfileState> emit)async {
    emit(LoadingState());
 try{
   await   appGetit.getUser(id: authServiceGetit.currentUser!.id);
   emit(SuccessState());
 }catch(e){
  emit(ErrorState(message: e.toString()));
 }
  }

  FutureOr<void> addAdminEventMethod(AddAdminEvent event, Emitter<ProfileState> emit) {
    emit(SuccessState());
  }
}
